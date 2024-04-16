include <config.scad>
include <stem_root.scad>
include <stem_post.scad>
include <stem_jack.scad>

module stem_cherry_1u(
    height=$STEM_CHERRY_BASE_HEIGHT, 
    breadth=$STEM_CHERRY_WING_BREADTH, 
    thickness=$STEM_CHERRY_WING_THICKNESS, 
    lift=$STEM_CHERRY_BASE_LIFT
) {
    assert(height>=3.6, "height must not be less than 3.6mm");

    diameter=breadth+thickness;
    
    union() {
        stem_jack(height=lift, breadth=breadth, thickness=thickness, spacing=0, tine_angle=12);
        translate([0, 0, lift])
        post_cherry_stem_geometry(height=$STEM_CHERRY_BASE_HEIGHT, breadth=breadth, thickness=thickness, spacing=0);
        translate([0, 0, lift+$STEM_CHERRY_BASE_HEIGHT])
        post_cherry_root_geometry(height=(height-$STEM_CHERRY_BASE_HEIGHT), breadth=breadth, thickness=thickness, spacing=0);   
    }
}

module stem_cherry_2u(
    height=$STEM_CHERRY_BASE_HEIGHT, 
    breadth=$STEM_CHERRY_WING_BREADTH, 
    thickness=$STEM_CHERRY_WING_THICKNESS, 
    spacing=$STEM_CHERRY_BASE_SPACING, 
    lift=$STEM_CHERRY_BASE_LIFT
) {
    assert(spacing>-1, "spacing cannot be negative");
    assert(height>=3.6, "height must not be less than 3.6mm");

    diameter=breadth+thickness;
    
    union() {
        stem_jack(height=lift, breadth=breadth, thickness=thickness, spacing=spacing, tine_angle=12);
        translate([0, 0, lift])
        post_cherry_root_geometry(height=(height-$STEM_CHERRY_BASE_HEIGHT), breadth=breadth, thickness=thickness, spacing=spacing);
        translate([0, 0, lift+$STEM_CHERRY_BASE_HEIGHT])
        post_cherry_stem_geometry(height=$STEM_CHERRY_BASE_HEIGHT, breadth=breadth, thickness=thickness, spacing=spacing);
    }
}
