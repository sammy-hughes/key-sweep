

slices=6;
height_base=2.5;
height_boost=12.5;
width=10;

sweep_angle=acos(height_base/(height_base+height_boost));
assert(sweep_angle>=0&&sweep_angle<=120, "sweep angle degrees must be between 0 and 120");
shift_angle=15;
assert(sweep_angle+shift_angle<=90, "the shifted sweep cannot exceed 90 degrees");
sweep_range=90-sweep_angle;


control_sin = sin(sweep_range+shift_angle+sweep_angle*2);

for (i=[0:slices-1]) {
    sweep_slice = sweep_range+shift_angle+sweep_angle/(slices-1)*i*2;
    pre_sweep = cos(sweep_slice)*(2/3);
    echo(pre_sweep);
    sweep_factor = (pre_sweep+pre_sweep*pow(abs(pre_sweep), 3))/2;
    height_factor = sin(sweep_slice)-control_sin;
   
    translate([width*1.1*i, 0, height_base])
    translate([0, 0, (height_boost-height_boost*height_factor)*0.5])
    rotate([0, sweep_angle*sweep_factor, 0])
    translate([0, 0, (height_boost-height_boost*height_factor)*0.5])
    cylinder(h=1, d=width);
    
}

cube([100, 1, 5]);
translate([0, 1, 0])
cube([100, 1, 10]);
translate([0, 2, 0])
cube([100, 1, 15]);