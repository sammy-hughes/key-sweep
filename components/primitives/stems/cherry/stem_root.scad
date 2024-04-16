include <config.scad>
include <stem_post.scad>

module post_cherry_root_well(width=$STEM_CHERRY_KEY_WIDTH, height=$STEM_CHERRY_BASE_HEIGHT , breadth=$STEM_CHERRY_WING_BREADTH, thickness=$STEM_CHERRY_WING_THICKNESS, spacing=$STEM_CHERRY_BASE_SPACING) {
    assert(spacing>-1, "spacing cannot be negative");

    module base_geometry(scale=width/breadth) {
        hull()
        linear_extrude(height=height, scale=scale)
        offset(r=thickness*2)
        offset(delta=-thickness, chamfer=true)
        square(breadth, center=true);
    }
    
    union() {
        linear_extrude(height=thickness*3, scale=1, center=true)
        post_cherry_stem_profile(breadth=breadth, thickness=thickness, spacing=spacing);
    
        if (spacing == 0) {
            difference() {
                base_geometry();
                
                translate([0, 0, thickness*0.5])
                base_geometry();
                
                linear_extrude(height=thickness*0.5)
                circle(d=breadth+thickness);
            }
        } else {
            difference() {
                hull()
                for (i=[-1:2:1])
                translate([spacing*i, 0, 0])
                base_geometry();
                
                translate([0, 0, thickness*0.5])
                hull()
                for (i=[-1:2:1])
                translate([spacing*i, 0, 0])
                base_geometry();
                
                linear_extrude(height=thickness*0.5)
                for (i=[-1:1:1])
                translate([spacing*i, 0, 0])
                circle(d=breadth+thickness);
            }
        }
    }
}

module post_cherry_vent_profile(breadth=$STEM_CHERRY_WING_BREADTH, thickness=$STEM_CHERRY_WING_THICKNESS, spacing=$STEM_CHERRY_BASE_SPACING) {
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
        translate([0, (breadth+thickness)*i, 0])
        base_profile();
    } else if (spacing <= 15) {
        for (i=[-1:1:1])
        for (j=[-1:2:1])
        translate([spacing*i, (breadth+thickness)*j, 0])
        base_profile();
    }
}

module post_cherry_root_geometry(width=$STEM_CHERRY_KEY_WIDTH, height=$STEM_CHERRY_BASE_HEIGHT, breadth=$STEM_CHERRY_WING_BREADTH, thickness=$STEM_CHERRY_WING_THICKNESS, spacing=$STEM_CHERRY_BASE_SPACING) {
    assert(spacing>-1, "spacing cannot be negative");
    
    difference() {
        post_cherry_root_well(height=height, width=width, breadth=breadth, thickness=thickness, spacing=spacing);

        linear_extrude(height=height, scale=1)
        post_cherry_vent_profile(breadth=breadth, thickness=thickness, spacing=spacing);
    }
}
