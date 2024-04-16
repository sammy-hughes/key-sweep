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
        if ($children > 0) {
            intersection() {
                children(0);
                scale([cavity*1.05, cavity*1.05, cavity*1.05])
                basic_shape(slices) children(1);
            }
        }
        
        difference() {
            basic_shape(slices) if ($children > 0) children(1);
            if (slices > 1) {
                scale([cavity, cavity, 1-(1-cavity)*0.5])
                basic_shape(slices-1) if ($children > 0) children(1);
            } else {
                scale([cavity, cavity, cavity])
                basic_shape(slices) if ($children > 0) children(1);
            }
        }
    }
}
//keycap_generic(width=[14, 2], r=[2, 4], face_offset=[0, 0, 15], face_angle=[37.5, 0, 0]);