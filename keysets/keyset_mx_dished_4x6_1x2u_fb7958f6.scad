/* 4x6 Ortholinear (with 1x2u)


*/
include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/fb7958f6/model.scad>;

$fn=15;
$BASE_R=2;
$FACE_R=4;
columns = 6;
rows = 4;

design=sweep_fb7958f6(height=20, sweep_angle=[30, 37.5], sweep_shift=[0, -30], slices=[columns, rows]);
function keyset_unit(i, j) = (
    i==4 && j==3? 2.0:
    i==5 && j==3? 0.0:
    1.0
);
keyset_symbol_source = [
    ["Tab", "Q", "W", "E", "R", "T"],
    ["Ctrl", "A", "S", "D", "F", "G"],
    ["Shift", "Z", "X", "C", "V", "B"],
    ["", "", "", "", "----", ""]
];
function keyset_symbol(i, j) = (
    [j, i] == [3, 5]? "":
    keyset_symbol_source[j][i]
);

module print_symbol(i, j, size=3, depth=1.25, fit_to_size=16) {
    base_symbol = keyset_symbol(i, j);
    actual_size = len(base_symbol)*size;
    
    linear_extrude(height=depth, scale=1.25)
    scale([0.8, 0.8, 1])
    if (actual_size > fit_to_size) {
        text(base_symbol, size*fit_to_size/actual_size, halign="center", valign="center");
    } else {
        text(base_symbol, size, halign="center", valign="center");
    }
}

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
    param_offset=[0, 0, design[i][j][1]];
    param_angle=[design[i][j][0][1], design[i][j][0][0], 0];
    if (keyset_unit(i, j) == 2) {
        translate([i*19+19*0.5, j*-19, 0])
        keycap_mx_spherical_200u(face_offset=param_offset, face_angle=[for (a=param_angle) -a], dimple_depth=0.5, slices=4, lift=3) {
            print_symbol(i, j);
        };
        
    } else if (keyset_unit(i, j) == 1) {
        translate([i*19, j*-19, 0])
        keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=0.5, slices=4, lift=3);
        print_symbol(i, j);
    } else {
        // do nothing
    }
}
