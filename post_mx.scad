module post_mx(height=10, breadth=4.1, thickness=1.17) {
    fudge = thickness*0.0625;
    diameter = breadth+thickness;
    module stem_profile(){
        offset(r=fudge*2)
        offset(delta=-fudge*2, chamfer=true)
        difference() {
            circle(d=diameter);
            
            offset(r=fudge*2)
            offset(delta=-fudge*2, chamfer=true)
            square([breadth+fudge, thickness+fudge], center=true);
            
            offset(r=fudge*2)
            offset(delta=-fudge*2, chamfer=true)
            square([thickness+fudge, breadth+fudge], center=true);
        }
    }

    difference() {
        union() {
            if (height > 4) {
                stem_height = 4;
                puck_height = height - stem_height;
                
                linear_extrude(height=stem_height)
                stem_profile();
                
                translate([0, 0, stem_height])
                linear_extrude(height=puck_height, scale=5)
                stem_profile();
            } else {
                linear_extrude(height=height)
                stem_profile();
            }        
        }
        cylinder(h=0.5, d1=diameter-thickness, d2=thickness);
        
        translate([0, diameter, 0])
        hull() {
            translate([-thickness, 0, 0])
            cylinder(h=height, r=thickness);
            translate([thickness, 0, 0])
            cylinder(h=height, r=thickness);
        }
        translate([0, -diameter, 0])
        hull() {
            translate([-thickness, 0, 0])
            cylinder(h=height, r=thickness);
            translate([thickness, 0, 0])
            cylinder(h=height, r=thickness);
        }
    }
}