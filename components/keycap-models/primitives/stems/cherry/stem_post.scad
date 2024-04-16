include <config.scad>

module post_cherry_stem_profile(
    breadth=$STEM_CHERRY_WING_BREADTH, 
    thickness=$STEM_CHERRY_WING_THICKNESS, 
    spacing=$STEM_CHERRY_BASE_SPACING
) {
    assert(spacing>-1, "spacing cannot be negative");
    fudge = thickness*0.0625;
    
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
    
    if (spacing == 0) {
        base_profile();
    } else if (spacing <=15) {
        for (i=[-1:1:1])
        translate([i*spacing, 0, 0])
        base_profile();
    }
}

module post_cherry_stem_geometry(
    height=$STEM_CHERRY_BASE_HEIGHT, 
    breadth=$STEM_CHERRY_WING_BREADTH, 
    thickness=$STEM_CHERRY_WING_THICKNESS, 
    spacing=$STEM_CHERRY_BASE_SPACING
) {
    assert(spacing>-1, "spacing cannot be negative");
    
    if (spacing == 0) {
        difference() {
            linear_extrude(height=height)
            post_cherry_stem_profile(breadth=breadth, thickness=thickness, spacing=spacing);

            cylinder(h=0.5, d1=breadth, d2=thickness);
        }
    } else if (spacing <= 15) {
        difference() {
            linear_extrude(height=height)
            post_cherry_stem_profile(breadth=breadth, thickness=thickness, spacing=spacing);
            
            for (i=[-1:1:1])
            translate([i*spacing, 0, 0])
            cylinder(h=0.5, d1=breadth, d2=thickness);
        }
    }
}
