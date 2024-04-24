include <config.scad>

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
$fn=90;
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
  assert(height-lift>=3.2, "height must exceed lift by at least 3.2mm");
  
  module boot() {
    translate([0, 0, lift])
    mirror([0,0,1])
    difference() {
      intersection() {
        for (i=[-1:2:1]) {
          rotate([0, 0, i*9])
          translate([i*thickness*0.0875, i*thickness*0.0875, 0])
          linear_extrude(height=lift, scale=2)
          offset(delta=-thickness*0.125)
          scale([1.0625, 1.0625, 1])
          post_cherry_stem_profile(breadth=breadth, thickness=thickness);
        }
      }
      cylinder(h=0.5, d1=breadth, d2=thickness);
    }
  }
  
  module base_geometry() {
    if (lift>0) boot();
    translate([0, 0, lift])
    difference() {
      linear_extrude(height=height-lift)
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
