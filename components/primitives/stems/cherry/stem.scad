include <config.scad>
include <stem_root.scad>
include <stem_post.scad>
include <stem_jack.scad>

module stem_cherry_1u(height=$STEM_CHERRY_DEFAULT_HEIGHT, breadth=$STEM_CHERRY_WING_BREADTH, thickness=$STEM_CHERRY_WING_THICKNESS) {
    assert(height>=3.6, "height must not be less than 3.6mm");

    diameter=breadth+thickness;
    
    union() {
        translate([0, 0, $STEM_CHERRY_DEFAULT_HEIGHT])
        post_cherry_root_geometry(height=(height-$STEM_CHERRY_DEFAULT_HEIGHT), breadth=breadth, thickness=thickness, spacing=0);
        post_cherry_stem_geometry(height=$STEM_CHERRY_DEFAULT_HEIGHT, breadth=breadth, thickness=thickness, spacing=0);

        // TODO: implement the lift parameter
    }
}

module stem_cherry_2u(height=$STEM_CHERRY_DEFAULT_HEIGHT, breadth=$STEM_CHERRY_WING_BREADTH, thickness=$STEM_CHERRY_WING_THICKNESS, spacing=$STEM_CHERRY_DEFAULT_SPACING) {
    assert(spacing>-1, "spacing cannot be negative");
    assert(height>=3.6, "height must not be less than 3.6mm");

    diameter=breadth+thickness;
    
    union() {
        translate([0, 0, $STEM_CHERRY_DEFAULT_HEIGHT])
        post_cherry_root_geometry(height=(height-$STEM_CHERRY_DEFAULT_HEIGHT), breadth=breadth, thickness=thickness, spacing=spacing);
        post_cherry_stem_geometry(height=$STEM_CHERRY_DEFAULT_HEIGHT, breadth=breadth, thickness=thickness, spacing=spacing);

        // TODO: implement the lift parameter
    }
}
