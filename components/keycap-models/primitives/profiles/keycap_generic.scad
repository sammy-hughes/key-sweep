CHILD_STEM=0;
CHILD_DIMPLE=1;

function with_bottom_inset_bevel(slices, rate) = function(i) (i<slices? 1-(slices-i)/slices*rate: 1);
function with_bottom_outset_bevel(slices, rate) = function(i) (i<slices? 1+(slices-i)/slices*rate: 1);
function with_round_off(slices, angle) = function (i) max((1+pow(cos(i/(slices-1)*angle),2))*0.5, 0.001);
function with_round_off_2nd_order(slices, angle) = function (i) max(
  with_round_off(slices, angle-angle*with_round_off(slices, angle)(i))(i),
  0.001
);

module keycap_generic(width=[14, 2], r=[2, 4], slices=15, face_offset=[0, 0, 30], face_angle=[37.5, 0, 0], cavity=0.90, unit=1.00) {
  d1 = width[0]+r[0]*2;
  assert(d1<=18, "primary size must not be greater than 18mm to fit MX spacing");
  d2 = width[1]+r[1]*2;
  assert(d2<=d1, "secondary size must not be greater than primary size");
  
  scale = d2/d1;
  curve = acos(scale);
  slice_angle = 90/slices;
  angle_index = [for (i=[0:slices]) [sin(slice_angle*i*pow(i/slices,0.0625)), cos(slice_angle*i*pow(i/slices,0.0625))]];
  function adjust_offsets(i, offsets) = (
    [
      offsets.x-offsets.x*angle_index[i].y,
      offsets.y-offsets.y*angle_index[i].y,
      offsets.z*angle_index[i].x
    ]
  );
  function adjust_angles(i, angles) = (
    [
      angles.x*angle_index[i].x,
      angles.y*angle_index[i].x,
      angles.z-angles.z*angle_index[i].y
    ]
  );
  function di_slice(i, a, b) = a>b? b+cos(slice_angle*i)*(a-b): b-cos(slice_angle*i)*(b-a);
  function r_slice(i) = di_slice(i, r[0], r[1]);
  function width_slice(i) =  di_slice(i, width[0], width[1]);
  
  module profile_slice(i) {
    module shape() {
      offset(r=r_slice(i))
      square(size=width_slice(i), center=true);
    }
    
    if (unit == 1) {
      shape();
    } else {
      x_unit=(unit-1)/2;
      x_offset=d1*x_unit;
      hull()
      for (x=[-x_offset:x_offset*2:x_offset]) {
        translate([x, 0, 0])
        shape();
      }
    }
  }

  module basic_shape(length=1, slice_scales) {
    difference() {
      union()
      for (i=[0:length-1])
      hull() {
        translate(adjust_offsets(i, face_offset))
        rotate(adjust_angles(i, [for (a=face_angle) a*1] ))
        linear_extrude(height=0.01)
        scale([slice_scales[i], slice_scales[i], 1])
        profile_slice(i);
        
        translate(adjust_offsets(i+1, face_offset))
        rotate(adjust_angles(i+1, [for (a=face_angle) a*1] ))
        linear_extrude(height=0.01)
        scale([slice_scales[i+1], slice_scales[i+1], 1])
        profile_slice(i+1);
      };

      translate(adjust_offsets(length, face_offset))
      rotate(adjust_angles(length, [for (a=face_angle) a*1] ))
      children();
    }
  }
  
  module surface_shape(length=slices) {
    rounding=with_round_off_2nd_order(length, 75);
    bevel=with_bottom_inset_bevel(round(length*0.125), 0.0125);
    basic_shape(length, [for (i=[0:length]) bevel(i)*rounding(i)])
    children();
  }
  
  module cavity_shape(length=slices) {
    rounding=with_round_off_2nd_order(length, 90);
    bevel_a = with_bottom_outset_bevel(round(length*0.25), 0.0625);
    bevel_b = with_bottom_inset_bevel(round(length*0.0625), 0.0625);
  
    scale([cavity, cavity, 1])
    intersection() {
      scale([1, 1, 1.05])
      basic_shape(length, [for (i=[0:length]) bevel_a(i)*bevel_b(i)*pow(rounding(i), 1.5)])
      scale([1/cavity, 1/cavity, 1/cavity])
      children();
      scale([1, 1, cavity])
      basic_shape(floor(length*cavity), [for (i=[0:length]) bevel_a(i)*bevel_b(i)*pow(rounding(i), 1.5)])
      scale([3/cavity, 3/cavity, 1/cavity])
      children();
    }
  }
  
  union() {
    if ($children > CHILD_STEM) {
      intersection() {
        children(CHILD_STEM);
        cavity_shape(slices)
        if ($children > CHILD_DIMPLE) 
        children(CHILD_DIMPLE);
      }
    }
    
    difference() {
      surface_shape(slices) 
      if ($children > CHILD_DIMPLE) 
      children(CHILD_DIMPLE);
      cavity_shape(slices)
      if ($children > CHILD_DIMPLE) 
      children(CHILD_DIMPLE);
      
      if ($children > CHILD_DIMPLE+1)
      translate(adjust_offsets(slices-1, face_offset))
      rotate(adjust_angles(slices-1, face_angle))
      children([CHILD_DIMPLE+1:$children-1]);
    }
  }
}

/*
keycap_generic(width=[14, 4], r=[2, 6], face_offset=[6, -16, 30], face_angle=[15, 30, 0], slices=30) {
  translate([0, 0, 3]) sphere(d=6);
  translate([0, 0, 30]) sphere(d=64);
};*/
