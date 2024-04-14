include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn=15;
rows = 3;
columns = 6;

design=sweep_c20563a3(height=20, sweep_angle=[30, 30], sweep_shift=[0, 0], slices=[6, 4]);
for (i=[0:len(design)-1])
for (j=[0:len(design[0])-1]) {
    echo(
    [i, j],
    [0, 0, design[i][j][1]],
    [design[i][j][0][1], design[i][j][0][0], 0]
    );
    translate([i*20, j*-20, 0])
    keycap_mx_spherical_100u(
        face_offset=[0, 0, design[i][j][1]],
        face_angle=[design[i][j][0][1], design[i][j][0][0], 0]
    );
}