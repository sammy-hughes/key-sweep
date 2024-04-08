

slices=6;
height=5;
sweep_angle=45;
height_min=(height+2*height*pow(cos(sweep_angle),3))/3;
height_swing=height-height_min;
width=10;

sweep_shift=45;


for (i=[0:slices-1]) {
    sweep_slice = (180)/(slices-1)*i;
    pre_sweep = cos(sweep_slice);
    height_slice = (180)/(slices-1)*i;
    sweep_factor = pre_sweep*abs(pre_sweep);
    
    translate([width*1.1*i, 0, 0])
    translate([0, 0, height-height_swing*abs(sin(height_slice))])
    rotate([0, sweep_angle*sweep_factor*0.5, 0])
    cylinder(h=1, d=width);
    
}
translate([-20, 0, 0]) {
    cube([100, 1, 5]);
    translate([0, 1, 0])
    cube([100, 1, 10]);
    translate([0, 2, 0])
    cube([100, 1, 15]);
}