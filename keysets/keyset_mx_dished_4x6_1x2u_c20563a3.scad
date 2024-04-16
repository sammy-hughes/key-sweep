include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn=15;
columns = 6;
rows = 4;

design=sweep_c20563a3(height=20, sweep_angle=[30, 37.5], sweep_shift=[0, -30], slices=[columns, rows]);
key_unit = [
  for (i=[0:columns-1]) [
    for (j=[0:rows-1]) (
        i==4 && j==3? 2.0:
        i==5 && j==3? 0.0:
        1.0
    )
    ]
];
for (i=[0:len(design)-1])
for (j=[0:len(design[0])-1]) {
    echo(design[i][j]);
    param_offset=[0, 0, design[i][j][1]];
    param_angle=[design[i][j][0][1], design[i][j][0][0], 0];
    if (key_unit[i][j] == 2) {
        translate([i*19+19*0.5, j*-19, 0])
        keycap_mx_spherical_200u(face_offset=param_offset, face_angle=[for (a=param_angle) -a], dimple_depth=0.5, slices=4, lift=3);
    } else if (key_unit[i][j] == 1 && i > 3 && j ==3) {
        translate([i*19, j*-19, 0])
        keycap_mx_spherical_100u(face_offset=param_offset, face_angle=[for (a=param_angle) -a], dimple_depth=0.5, slices=4, lift=3);
    } else if (key_unit[i][j] == 1) {
        translate([i*19, j*-19, 0])
        keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=0.5, slices=4, lift=3);
    } else {
        // do nothing
    }
}
