include <config.scad>

module stem_boot(
    breadth=$STEM_CHERRY_WING_BREADTH,
    thickness=$STEM_CHERRY_WING_THICKNESS,
    lift=$STEM_CHERRY_BASE_LIFT
) {
  boot_diameter_od = breadth+thickness*1.5;
  boot_diameter_id = breadth;
  tab_z_offset = max(lift-thickness*0.5, lift*0.5);
  tab_height = lift-tab_z_offset;
  foot_height = min(thickness, lift*0.1);
  
  module profile() {
    difference() {
      circle(d=boot_diameter_od);
      circle(d=boot_diameter_id);
      for (a=[0:45:180]) {
        rotate([0, 0, a])
        square([boot_diameter_od, thickness*0.5], center=true);
      }
    }
  }
  
  union() {
    linear_extrude(height=foot_height)
    hull()
    offset(r=thickness)
    profile();
    
    linear_extrude(height=tab_z_offset)
    profile();
    
    translate([0, 0, tab_z_offset])
    linear_extrude(height=tab_height, scale=0.95)
    offset(delta=-thickness*0.25)
    profile();
    
  }
}

module test_stem_boot() {
  stem_boot(lift=3);
}

// test_stem_boot();