include <config.scad>
include <stem_post.scad>

module post_cherry_root_well(
  width=$STEM_CHERRY_KEY_WIDTH, 
  height=$STEM_CHERRY_BASE_HEIGHT, 
  breadth=$STEM_CHERRY_WING_BREADTH, 
  thickness=$STEM_CHERRY_WING_THICKNESS, 
  spacing=$STEM_CHERRY_BASE_SPACING
) {
  assert(spacing>-1, "spacing cannot be negative");

  module base_geometry() {
    scale_factor=height/(breadth+thickness)*2;
    hull()
    linear_extrude(height=height, scale=scale_factor)
    offset(r=thickness*2)
    offset(delta=-thickness, chamfer=true)
    square(breadth, center=true);
  }
  
  module root_transition() {
    intersection() {
      linear_extrude(height=thickness*2, scale=1.325, center=true)
      offset(r=thickness*0.0625)
      post_cherry_stem_profile(breadth=breadth, thickness=thickness);
      mirror([0, 0, 1])
      linear_extrude(height=thickness*2, scale=1.325, center=true)
      offset(r=thickness*0.0625)
      post_cherry_stem_profile(breadth=breadth, thickness=thickness);
    }
  }
  
  union() {
    if (spacing == 0) {
      difference() {
        base_geometry();
        
        translate([0, 0, thickness])
        base_geometry();
        
        linear_extrude(height=thickness)
        circle(d=breadth+thickness);
      }
        
      root_transition();
    } else {
      difference() {
        hull()
        for (i=[-1:2:1])
        translate([spacing*i, 0, 0])
        base_geometry();
        
        translate([0, 0, thickness])
        hull()
        for (i=[-1:2:1])
        translate([spacing*i, 0, 0])
        base_geometry();
        
        linear_extrude(height=thickness)
        for (i=[-1:1:1])
        translate([spacing*i, 0, 0])
        circle(d=breadth+thickness);
      }
      
      for (i=[-1:1:1])
      translate([spacing*i, 0, 0])
      root_transition();
    }
  }
}

module post_cherry_vent_profile(
  breadth=$STEM_CHERRY_WING_BREADTH, 
  thickness=$STEM_CHERRY_WING_THICKNESS, 
  spacing=$STEM_CHERRY_BASE_SPACING
) {
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

module post_cherry_root_geometry(
  width=$STEM_CHERRY_KEY_WIDTH, 
  height=$STEM_CHERRY_BASE_HEIGHT, 
  breadth=$STEM_CHERRY_WING_BREADTH, 
  thickness=$STEM_CHERRY_WING_THICKNESS, 
  spacing=$STEM_CHERRY_BASE_SPACING
) {
  assert(spacing>-1, "spacing cannot be negative");
  
  difference() {
    post_cherry_root_well(height=height, width=width, breadth=breadth, thickness=thickness, spacing=spacing);

    linear_extrude(height=height, scale=1)
    post_cherry_vent_profile(breadth=breadth, thickness=thickness, spacing=spacing);
  }
}
