$fn=90;

module mx_stem(height=10, breadth=4, thickness=1) {
    fudge = 0.125;
    diameter = breadth*1.0625;
    module stem_profile(){
        difference() {
            circle(d=diameter+fudge);
            circle(d=thickness*2+fudge);
            square([breadth+fudge, thickness+fudge], center=true);
            square([thickness+fudge, breadth+fudge], center=true);
        }
    }

    difference() {
        cylinder(d=diameter, h=height);
        linear_extrude(height=height)
        stem_profile();
    }
}

union() {
    scale([0.95, 0.95, 1])
    mx_stem(height=40);
    translate([0, 0, -7])
    difference() {
        sphere(r=10);
        translate([0, 0, -10])
        intersection() {
            cylinder(h=15, d1=20, d2=7);
            cylinder(h=15, d1=4, d2=20);
        }
        translate([0, 0, -10])
        cylinder(h=3, d=8);
    }
    translate([0, 0, -16.25])
    difference() {
        cylinder(h=3, d=8);
        cylinder(h=3, d=4);
    }
}