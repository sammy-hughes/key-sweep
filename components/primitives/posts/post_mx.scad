module post_cherry_root_profile(d=5.27, spacing=11) {
    assert(spacing>-1, "spacing cannot be negative");

    if (spacing == 0) {
        circle(d=d);
    } else {  
        hull()
        for (i=[-1:2:1])
        translate([spacing*i, 0, 0])
        circle(d=d);
    }
}

module post_cherry_vent_profile(breadth=4.1, thickness=1.17, spacing=11) {
    assert(spacing>-1, "spacing cannot be negative");

    module base_profile() {
        hull() {
            translate([-thickness, 0, 0])
            circle(r=thickness);
            translate([thickness, 0, 0])
            circle(r=thickness);
        }
    }

    if (spacing == 0) {
        for (i=[-1:2:1])
        translate([0, (breadth+thickness)*j, 0])
        base_profile();
    } else if (spacing <= 15) {
        for (i=[-1:1:1])
        for (j=[-1:2:1])
        translate([spacing*i, (breadth+thickness)*j, 0])
        base_profile();
    }
}

module post_cherry_root_geometry(height=3.6, breadth=4.1, thickness=1.17, spacing=11) {
    assert(spacing>-1, "spacing cannot be negative");
    
    d1 = breadth+thickness;
    d2 = d1*4;

    difference() {
        linear_extrude(height=height, scale=d2/d1)
        post_cherry_root_profile(d=d, spacing=11);

        linear_extrude(height=height, scale=1)
        post_cherry_vent_profile(breadth=breadth, thickness=thickness, spacing=11);
    }
}

module post_cherry_stem_profile(breadth=4.1, thickness=1.17, spacing=11) {
    assert(spacing>-1, "spacing cannot be negative");
    fudge = thickness*0.125;
    
    module base_profile() {
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
}

module post_cherry_stem_geometry(height=3.6, breadth=4.1, thickness=1.17, spacing=11) {
    assert(spacing>-1, "spacing cannot be negative");
    
    module base_geometry() {
        difference() {
            linear_extrude(height=height)
            post_cherry_stem_profile(height=height, breadth=breadth, thickness=thickness);
            cylinder(h=0.5, d1=breadth, d2=thickness);
        }
    }
    
    if (spacing == 0) {
        base_geometry();
    } else if (spacing <= 15) {
        for (i=[-1:1:1]) 
        translate([0, 0, i*spacing]) 
        base_geometry();
    }
}

module post_cherry_jack_geometry(height=1, breadth=4.1, thickness=1.17, spacing=11) {
    d1=breadth+thickness;
    d2=d1+thickness;
    
}

module post_cherry(height=10, breadth=4.1, thickness=1.17) {
    difference() {
        union() {
            post_cherry_stem_core(height=4, breadth=breadth, thickness=thickness);
        
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

module post_cherry_2u(height=10, breadth=4.1, thickness=1.17, spacing=11) {
    assert(spacing>-1, "spacing cannot be negative");
    assert(height>=3.6, "height must not be less than 3.6mm");

    diameter=breadth+thickness;
    
    difference() {
        union() {
            for (i=[-1:1:1])
            translate([spacing*i, 0, 0])
            post_cherry_stem(height=4, breadth=breadth, thickness=thickness);
            
            if (height > 4) {
                translate([0, 0, 4]) {
                    linear_extrude(height=thickness)
                    difference() {
                        post_cherry_root_profile(d=breadth+thickness, spacing=spacing);
                        for (i=[-1:1:1])
                        translate([spacing*i, 0, 0])
                        difference() {
                            circle(d=breadth);
                            post_cherry_stem_profile(height=height, breadth=breadth, thickness=thickness);
                        }
                    }
                    linear_extrude(height=height-4, scale=5)
                    difference() {
                        post_cherry_root_profile(d=breadth+thickness, spacing=spacing);
                        post_cherry_root_profile(d=breadth, spacing=spacing);
                    }
                }
            }
        }
        
        linear_extrude(height=height) 
        post_cherry_vent_profile(breadth=breadth, thickness=thickness, spacing=spacing);
    }
}
