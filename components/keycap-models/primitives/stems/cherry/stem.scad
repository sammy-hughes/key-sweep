include <config.scad>
include <stem_root.scad>
include <stem_post.scad>

module stem_cherry_1u(
  height=$STEM_CHERRY_BASE_HEIGHT, 
  breadth=$STEM_CHERRY_WING_BREADTH, 
  thickness=$STEM_CHERRY_WING_THICKNESS, 
  lift=$STEM_CHERRY_BASE_LIFT
) {
  stem_cherry_2u(height=height, breadth=breadth, thickness=thickness, lift=lift, spacing=0);
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
  assert(height-lift>=3.6, "total height must exceed lift by at least 3.6mm");

  diameter=breadth+thickness;
  stem_height=$STEM_CHERRY_BASE_HEIGHT+lift;
  root_height=height-stem_height;

  union() {
    post_cherry_stem_geometry(height=stem_height, breadth=breadth, thickness=thickness, spacing=spacing, lift=lift);
    translate([0, 0, lift+$STEM_CHERRY_BASE_HEIGHT])
    post_cherry_root_geometry(height=root_height, breadth=breadth, thickness=thickness, spacing=spacing);   
  }
}
