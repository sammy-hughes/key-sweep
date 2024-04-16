include <config.scad>
include <stem_post.scad>

module stem_jack(
    height=$STEM_CHERRY_BASE_HEIGHT, 
    breadth=$STEM_CHERRY_WING_BREADTH, 
    thickness=$STEM_CHERRY_WING_THICKNESS, 
    spacing=$STEM_CHERRY_BASE_SPACING, 
    tine_angle=12
) {
    base_width=breadth+thickness;
    overlap_height=2;
    base_height=height+overlap_height;
    
    module base_geometry() {
        union() {
            difference() {
                translate([0, 0, -height])
                linear_extrude(height=base_height, scale=0.775)
                circle(d=base_width*2);

                linear_extrude(height=overlap_height, scale=1.05)
                circle(d=base_width*0.9625);
                
                rotate([180, 0, 0])
                linear_extrude(height=height, scale=0.5)
                circle(d=base_width*0.9125);
                
                translate([0, 0, overlap_height])
                rotate([180, 0, 0])
                linear_extrude(height=base_height)
                offset(r=base_width*0.0325)
                union() {
                    for(i=[0:tine_angle:360-tine_angle]) 
                    rotate([0, 0, i])
                    translate([-base_width*0.25, base_width*0.425, 0])
                    square([base_width*0.0125, base_width*0.25]); 
                }
            }
        }
    }
    
    translate([0, 0, height]) {
        if (spacing == 0) {
            base_geometry();
        } else if (spacing <=15) {
            for (i=[-1:1:1]) {
                translate([spacing*i, 0, 0])
                base_geometry();
            }
        }
        
        children();
    }
}
