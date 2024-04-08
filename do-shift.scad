

slices=6;
height=10;
sweep_angle=45;
sweep_shift=-30;
height_min=height*0.25+height*0.75*pow(cos(sweep_angle+abs(sweep_shift)),4);
height_swing=height-height_min;
width=10;

base_shift = sweep_shift<0? 0: sweep_shift;

for (i=[0:slices-1]) {
    sweep_slice = base_shift+(180-abs(sweep_shift))/(slices-1)*i;
    pre_sweep = cos(sweep_slice);
    height_slice = base_shift+(180-abs(sweep_shift))/(slices-1)*i;
    sweep_factor = (pre_sweep+pow(pre_sweep,3))/2;
    
    translate([width*1.1*i, 0, 0])
    translate([0, 0, height-height_swing*abs(sin(height_slice))])
    rotate([0, sweep_angle*sweep_factor, 0])
    cylinder(h=1, d=width);
    
}
translate([-20, 0, 0]) {
    cube([100, 1, 5]);
    translate([0, 1, 0])
    cube([100, 1, 10]);
    translate([0, 2, 0])
    cube([100, 1, 15]);
}