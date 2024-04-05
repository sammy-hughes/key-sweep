module post_mx_stem_profile(height=10, breadth=4.1, thickness=1.17) {
    fudge = thickness*0.0625;
    
    offset(r=fudge*2)
    offset(delta=-fudge*2, chamfer=true)
    difference() {
        circle(d=breadth+thickness);
        
        offset(r=fudge*2)
        offset(delta=-fudge*2, chamfer=true)
        square([breadth+fudge, thickness+fudge], center=true);
        
        offset(r=fudge*2)
        offset(delta=-fudge*2, chamfer=true)
        square([thickness+fudge, breadth+fudge], center=true);
    }
}

module post_mx_stem(height=10, breadth=4.1, thickness=1.17) {
    difference() {
        linear_extrude(height=height)
        post_mx_stem_profile(height=height, breadth=breadth, thickness=thickness);
        cylinder(h=0.5, d1=breadth, d2=thickness);
    }
}

module post_mx(height=10, breadth=4.1, thickness=1.17) {
    difference() {
        union() {
            post_mx_stem(height=4, breadth=breadth, thickness=thickness);
        
            if (height > 4) {
                stem_height = 4;
                puck_height = height - stem_height;
                
                translate([0, 0, stem_height])
                linear_extrude(height=puck_height, scale=5)
                difference() {
                    circle(d=breadth+thickness);
                    circle(d=breadth);
                }
            }       
        }
        
        for (i=[-1:2:1])
        translate([0, (breadth+thickness)*i, 0])
        hull() {
            translate([-thickness, 0, 0])
            cylinder(h=height, r=thickness);
            translate([thickness, 0, 0])
            cylinder(h=height, r=thickness);
        }
    }
}

module post_mx_2u(height=10, breadth=4.1, thickness=1.17, spacing=11) {
    diameter=breadth+thickness;
    
    module footprint(d=breadth+thickness) {
        hull()
        for (i=[-1:2:1])
        translate([spacing*i, 0, 0])
        circle(d=d);        
    }
    
    difference() {
        union() {
            for (i=[-1:1:1])
            translate([spacing*i, 0, 0])
            post_mx_stem(height=4, breadth=breadth, thickness=thickness);
            
            if (height > 4) {
                translate([0, 0, 4]) {
                    linear_extrude(height=thickness)
                    difference() {
                        footprint(d=breadth+thickness);
                        for (i=[-1:1:1])
                        translate([spacing*i, 0, 0])
                        difference() {
                            circle(d=breadth);
                            post_mx_stem_profile(height=height, breadth=breadth, thickness=thickness);
                        }
                    }
                    linear_extrude(height=height-4, scale=5)
                    difference() {
                        footprint(d=breadth+thickness);
                        footprint(d=breadth);
                    }
                }
            }
        }
        
        for (i=[-1:1:1])
        for (j=[-1:2:1])
        translate([spacing*i, (breadth+thickness)*j, 0])
        hull() {
            translate([-thickness, 0, 0])
            cylinder(h=height, r=thickness);
            translate([thickness, 0, 0])
            cylinder(h=height, r=thickness);
        }
    }
}
