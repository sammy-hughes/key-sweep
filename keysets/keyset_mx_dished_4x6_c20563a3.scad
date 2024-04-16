include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn= 15;
columns = 6;
rows = 4;

design=sweep_c20563a3(height=20, sweep_angle=[30, 37.5], sweep_shift=[0, -30], slices=[columns, rows]);
for (i=[0:len(design)-1])
for (j=[0:len(design[0])-1]) {
    param_offset=[0, 0, design[i][j][1]];
    param_angle=[design[i][j][0][1], design[i][j][0][0], 0];
    translate([i*19, j*-19, 0])
    keycap_mx_spherical_100u(face_offset=param_offset, face_angle=[for (a=param_angle) -a], dimple_depth=0.5, slices=6, lift=3);
}
