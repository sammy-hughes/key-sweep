include <config.scad>

module keycap_boot(
    width=$BASE_WIDTH,
    r=$BASE_R,
    cavity=$CAVITY_RATIO,
    unit=1.00,
    lift=$STEM_CHERRY_BASE_LIFT
) {
  foot_height= lift*0.125;
  tine_size=width*0.1;
  function intervals(length, step) = round(length/step)-1;
  function range(length, step) = [for (i=[-intervals(length, step)*0.5:1:intervals(length, step)*0.5]) step*i];
  half_tine=tine_size*0.5;
  quarter_tine=half_tine*0.5;
  
  module profile() {
    size = [width*unit, width];
    
    difference() {
      // contour
      offset(r=r)
      square(size=size, center=true);
      
      // hole
      scale([cavity, cavity, 1])
      offset(r=r)
      square(size=size, center=true);
    }
  }
  
  module tines() {
    difference() {
      profile();
      
      for (x=range(width*unit, tine_size*2))
        translate([x, 0, 0])
        square([tine_size, width*unit*2], center=true);
      
      for (y=range(width, tine_size*2))
        translate([0, y, 0])
        square([width*unit*2, tine_size], center=true);
    }
  }
  
  if (lift > 0) {
    union() {
      linear_extrude(height=foot_height)
      difference() {
        hull()
        profile();
        
        offset(delta=-r*4)
        hull()
        profile();
      }
      
      linear_extrude(height=lift*0.9)
      offset(r=tine_size*0.25)
      offset(delta=-tine_size*0.25)
      tines();
      
      translate([0, 0, lift*0.9])
      linear_extrude(height=lift*0.1)
      offset(delta=-tine_size*0.25)
      tines();
    }
  }
}

module test_boot_profile() {
  $fn=90;
  $CAVITY_RATIO=0.9;
  keycap_boot(lift=3, unit=1);
  translate([0, 0, 3])
  linear_extrude(height=1)
  offset(r=$BASE_R)
  square([$BASE_WIDTH*1, $BASE_WIDTH], center=true);
}

// test_boot_profile();