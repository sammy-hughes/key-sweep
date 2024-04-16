include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn=45;
rows = 3;
columns = 6;

design=sweep_c20563a3(height=15, sweep_angle=[30, 30], sweep_shift=[0, 0], slices=[6, 4]);
for (i=[0:len(design)-1])
for (j=[0:len(design[0])-1]) {
    translate([i*19, j*-19, 0])
    keycap_mx_spherical_100u(
        face_offset=[0, 0, design[i][j][1]],
        face_angle=[design[i][j][0][1], design[i][j][0][0], 0],
        dimple_depth=0.5,
        slices=15,
        lift=3
    );
}
