/* 4x6 Ortholinear (with 1x2u)


*/
include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/fb7958f6/model.scad>;

$fn=90;
$BASE_R=2;
$FACE_WIDTH=6;
$FACE_R=3;
columns = 6;
rows = 4;

function keyset_unit_a(i, j) = (
    i==4 && j==3? 2.0:
    i==5 && j==3? 0.0:
    1.0
);
function keyset_unit_b(i, j) = (
    i==1 && j==3? 2.0:
    i==0 && j==3? 0.0:
    1.0
);
keyset_symbol_source_a = [
    ["Tab", "Q", "W", "E", "R", "T"],
    ["Ctrl", "A", "S", "D", "F", "G"],
    ["Shift", "Z", "X", "C", "V", "B"],
    ["", "", "", "", "----", ""]
];
keyset_symbol_source_b = [
    ["Y", "U", "I", "O", "P", "+"],
    ["H", "J", "K", "L", ";", "'"],
    ["N", "M", "<", ">", "?", "-"],
    ["", "Enter", "", "", "", ""]
];
function keyset_symbol_a(i, j) = (
    [j, i] == [3, 5]? "":
    keyset_symbol_source_a[j][i]
);
function keyset_symbol_b(i, j) = (
    [j, i] == [3, 0]? "":
    keyset_symbol_source_b[j][i]
);
module print_symbol(base_symbol, size=4, depth=0.5, fit_to_size=16) {
    actual_size = len(base_symbol)*size;
    translate([0, 0, fit_to_size-depth*1.5])
    intersection() {
      hull() {
        for(i=[-1:2:1])
        translate([i*actual_size*0.25, 0, 0])
        sphere(d=fit_to_size*2);
      }
      linear_extrude(height=fit_to_size*2, center=true)
      offset(r=0.125, chamfer=true)
      offset(delta=0.25, chamfer=true)
      if (actual_size > fit_to_size) {
          text(base_symbol, size*fit_to_size/actual_size, halign="center", valign="center");
      } else {
          text(base_symbol, size, halign="center", valign="center");
      }
    }
}


design_a=sweep_fb7958f6(height=20, sweep_angle=[30, 22.5], sweep_shift=[0, 0], slices=[columns, rows]);
translate([-70, -105, 0])
rotate([0, 0, 90])
for (i=[0:len(design_a)-1])
for (j=[0:len(design_a[0])-1]) {
    param_offset=[-(columns-i-1)*0.5, (j==3 && i<2? 0: 1)*(columns-i-1)*0.5, (j==3 && i>1 && i<4? 0.85: j==3 && i>3? 0.9: 1)*design_a[i][j][1]];
    param_angle=[
      (j==3?-10:0)+(
        j==3 && i>1 && i<4? abs(design_a[i][j][0][0]*3): 
        j==3 && i>3? -design_a[i][j][0][0]:
        design_a[i][j][0][1]
      ), (j==3?0.75:1)*( 
        j==3 && i>1 && i<4? 0:
        j==3 && i>3? design_a[i][j][0][1]*0.5: design_a[i][j][0][0]
      ),
      (j==3 && i>3? -1: j==3 && i<2? -1: j==3? 1: -1)*((rows-1-j)+i)*2
    ];

    if (keyset_unit_a(i, j) == 2) {
        translate([i*19+19*0.5, j*-19, 0])
        keycap_mx_spherical_200u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=1.4, cavity=0.92)
        print_symbol(keyset_symbol_a(i, j), depth=0.75);
    } else if (keyset_unit_a(i, j) == 1) {
        translate([i*19, j*-19, 0])
        keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=1.4, cavity=0.92)
        print_symbol(keyset_symbol_a(i, j), depth=0.75);
    } else {
        // do nothing
    }
}

design_b=sweep_fb7958f6(height=20, sweep_angle=[30, 22.5], sweep_shift=[0, 0], slices=[columns, rows]);
translate([70, -10, 0])
rotate([0, 0, -90])
for (i=[0:len(design_b)-1])
for (j=[0:len(design_b[0])-1]) {
    param_offset=[i*0.5, (j==3 && i>3? 0: 1)*i*0.3, (j==3 && i>1 && i<4? 0.85: j==3 && i<2? 0.9: 1)*design_b[i][j][1]];
    param_angle=[
      (j==3?-10:0)+(
        j==3 && i>1 && i<4? abs(design_b[i][j][0][0]*3): 
        j==3 && i<2? abs(design_b[i][j][0][0]):
        design_b[i][j][0][1]
      ), (j==3?0.75:1)*( 
        j==3 && i>1 && i<4? 0:
        j==3 && i<2? -design_b[i][j][0][1]*0.5: design_b[i][j][0][0]
      ),
      (j==3 && i <2? 1: j==3 && i<2? 1: j==3? -1: 1)*((rows-1-j)+(columns-i-1))*2
    ];
    
    if (keyset_unit_b(i, j) == 2) {
        translate([i*19+-19*0.5, j*-19, 0])
        keycap_mx_spherical_200u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=1.4, cavity=0.92)
        print_symbol(keyset_symbol_b(i, j), depth=0.75);
    } else if (keyset_unit_b(i, j) == 1) {
        translate([i*19, j*-19, 0])
        keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=1.4, cavity=0.92)
        print_symbol(keyset_symbol_b(i, j), depth=0.75);
    } else {
        // do nothing
    }
}