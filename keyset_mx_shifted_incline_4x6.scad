include <keycap_mx_spherical_dimpled.scad>;

rows = 4;
columns = 6;
elevation = 50;

function curve_slice(i) = cos(90/(columns-1)*i);

for (i=[0:columns-1])
for (j=[0:rows-1])
translate([i*20, j*-20, 0]){
    tilt_y = -45+(30*curve_slice(i));
    
    tilt_x = (
        j==0? 15+15*curve_slice(i):
        j==1? 7.5+1.5*curve_slice(i):
        j==rows-2? -7.5+-1.5*curve_slice(i):
        j==rows-1? -15+-15*curve_slice(i):
        0
    );
    
    push_z = elevation-elevation*curve_slice(i)+(
        j==0? 11+3*curve_slice(i):
        j==1? 7+1*curve_slice(i):
        j==rows-2? 7+1*curve_slice(i):
        j==rows-1? 11+3*curve_slice(i):
        3
    );
    
    push_x = -6+6*curve_slice(i);
    push_y = 6*curve_slice(i)+ (-6-(-6)*curve_slice(i));
    keycap_mx_spherical_dimpled(face_offset=[push_x, push_y, push_z], face_angle=[tilt_x, tilt_y, 0]);
}