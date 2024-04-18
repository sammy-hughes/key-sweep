CHILD_STEM=0;
CHILD_DIMPLE=1;


module keycap_generic(width=[14, 2], r=[2, 4], slices=15, face_offset=[0, 0, 30], face_angle=[37.5, 0, 0], cavity=0.90, unit=1.00) {
    d1 = width[0]+r[0]*2;
    assert(d1<=18, "primary size must not be greater than 18mm to fit MX spacing");
    d2 = width[1]+r[1]*2;
    assert(d2<=d1, "secondary size must not be greater than primary size");
    
    scale = d2/d1;
    curve = acos(scale);

    slice_angle = 90/slices;
    angle_index = [for (i=[0:slices]) [sin(slice_angle*i), cos(slice_angle*i)]];
    function di_slice(i, a, b) = a>b? b+cos(slice_angle*i)*(a-b): b-cos(slice_angle*i)*(b-a);
    function r_slice(i) = di_slice(i, r[0], r[1]);
    function width_slice(i) =  di_slice(i, width[0], width[1]);
    
    module profile_slice(i) {
        module shape() {
          chamfer_factor = (
            i==0? 0.95:
            i==1? 0.97:
            i==2? 0.99:
            1.0
          );
          
          offset(r=r_slice(i)*(chamfer_factor+(1-chamfer_factor)*0.5))
          square(size=width_slice(i)*chamfer_factor, center=true);
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

    module basic_shape(length=1) {
        difference() {
            union()
            for (i=[0:length-1])
            hull() {
                translate([for (a=face_offset) a*angle_index[i].x*0.5])
                rotate([for (a=face_angle) a*angle_index[i].x])
                translate([for (a=face_offset) a*angle_index[i].x*0.5])
                linear_extrude(height=0.01)
                profile_slice(i);
                
                translate([for (a=face_offset) a*angle_index[i+1].x*0.5])
                rotate([for (a=face_angle) a*angle_index[i+1].x])
                translate([for (a=face_offset) a*angle_index[i+1].x*0.5])
                linear_extrude(height=0.01)
                profile_slice(i+1);
            }

            translate([for (a=face_offset) a*angle_index[length].x*0.5])
            rotate([for (a=face_angle) a*angle_index[length].x])
            translate([for (a=face_offset) a*angle_index[length].x*0.5])
            children();
        }
    }
    
    union() {
        if ($children > CHILD_STEM) {
            intersection() {
                children(CHILD_STEM);
                scale([cavity, cavity, cavity])
                basic_shape(slices) 
                if ($children > CHILD_DIMPLE)
                children(CHILD_DIMPLE);
            }
        }
        
        difference() {
            basic_shape(slices) 
            if ($children > CHILD_DIMPLE) 
            children(CHILD_DIMPLE);
            scale([cavity, cavity, cavity])
            basic_shape(slices) 
            if ($children > CHILD_DIMPLE)
            scale([8, 8, 2])
            translate([0, 0, 0])
            children(CHILD_DIMPLE);
            
            if ($children > CHILD_DIMPLE+1)
            translate([for (a=face_offset) a*angle_index[slices-1].x*0.5])
            rotate([for (a=face_angle) a*angle_index[slices-1].x])
            translate([for (a=face_offset) a*angle_index[slices-1].x*0.5])
            children([CHILD_DIMPLE+1:$children-1]);
        }
    }
}
//keycap_generic(width=[14, 2], r=[2, 4], face_offset=[0, 0, 15], face_angle=[37.5, 0, 0]);