include <config.scad>
include <stem_boot.scad>

module post_cherry_stem_profile(
    breadth=$STEM_CHERRY_WING_BREADTH, 
    thickness=$STEM_CHERRY_WING_THICKNESS
) {


  offset(r=thickness*0.125)
  offset(delta=-thickness*0.125, chamfer=true)
  difference() {
    circle(d=breadth+thickness);
    
    offset(r=thickness*0.125)
    offset(delta=-thickness*0.125, chamfer=true)
    square([breadth, thickness], center=true);
    
    offset(r=thickness*0.125)
    offset(delta=-thickness*0.125, chamfer=true)
    square([thickness, breadth], center=true);
  }
}

module post_cherry_stem_geometry(
    height=$STEM_CHERRY_BASE_HEIGHT, 
    breadth=$STEM_CHERRY_WING_BREADTH, 
    thickness=$STEM_CHERRY_WING_THICKNESS, 
    spacing=$STEM_CHERRY_BASE_SPACING,
    lift=$STEM_CHERRY_BASE_LIFT
) {
  assert(spacing>-1, "spacing cannot be negative");
  assert(lift>-1, "lift cannot be negative");
  assert(height>=3.6, "height must not be less than 3.6mm");
  //assert(height-lift>=3.6, "height must exceed lift by at least 3.6mm");
  
  module base_geometry() {
    translate([0, 0, lift])
    difference() {
      linear_extrude(height=height)
      post_cherry_stem_profile(breadth=breadth, thickness=thickness);

      cylinder(h=0.5, d1=breadth, d2=thickness);
    }
  }
  
  if (spacing == 0) {
    base_geometry();
  } else if (spacing <=15) {
    for (i=[-1:1:1])
    translate([i*spacing, 0, 0])
    base_geometry();
  }
}
