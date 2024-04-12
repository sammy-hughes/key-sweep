include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn=90;
rows = 3;
columns = 6;

design=sweep_c20563a3(height=[5, 10], sweep_angle=[45, 45], sweep_shift=[0, 0], slices=[3, 6]);
for (i=[0:columns-1])
for (j=[0:rows-1]) {
    echo(design[i][j]);
    translate([i*20, j*-20, 0])
    keycap_mx_spherical_100u(face_offset=[0, 0, 3.6+(design[i][j][1][0]+design[i][j][1][1])], face_angle=[design[i][j][0][0], design[i][j][0][1], 0]);
}
translate([0, 0, -40])
for (i=[0:columns-1])
for (j=[0:rows-1])
translate([i*20, j*-20, 0]){
    tilt_y = (
       i==0? 15:
       i==1? 7.5:
       i==columns-2? -7.5:
       i==columns-1? -15:
       0
    );
    
    tilt_x = (
        j==0? 22.5:
        j==rows-1? -22.5:
        0
    );
    
    push_z = (
        i==0? 9:
        i==1? 3:
        i==4? 3:
        i==5? 9:
        1
    )+(
        j==0? 7:
        j==rows-1? 7:
        5
    );
    
    keycap_mx_spherical_100u(face_offset=[0, 0, push_z], face_angle=[tilt_x, tilt_y, 0]);
}