include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn=90;
$BASE_WIDTH=15;
$BASE_R=1.3;
$FACE_WIDTH=4;
$FACE_R=3.6;
columns = 6;
rows = 4;
stem_lift=0;

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
    ["OS", "A", "S", "D", "F", "G"],
    ["Shift", "Z", "X", "C", "V", "B"],
    ["Esc", "`", "Ctrl", "Fn1", "----", ""]
];
keyset_symbol_source_b = [
    ["Y", "U", "I", "O", "P", "+"],
    ["H", "J", "K", "L", ";", "'"],
    ["N", "M", "<", ">", "?", "-"],
    ["", "Enter", "Fn2", "Alt", "|", "Backspace"]
];
function keyset_symbol_a(i, j) = (
    [j, i] == [3, 5]? "":
    keyset_symbol_source_a[j][i]
);
function keyset_symbol_b(i, j) = (
    [j, i] == [3, 0]? "":
    keyset_symbol_source_b[j][i]
);
module print_symbol(base_symbol, size=4, depth=0.5, fit_to_size=13, cavity=0.9) {
    actual_size = len(base_symbol)*size;
    
    module base_symbol() {
      if (actual_size > fit_to_size) {
          text(base_symbol, size*fit_to_size/actual_size, halign="center", valign="center");
      } else {
          text(base_symbol, size, halign="center", valign="center");
      }
    }
    
    translate([0, 0, -(depth*0.5)])
    intersection() {
      scale([1, 1, 0.125])
      hull()
      if (actual_size>size) {
        for (i=[-1:1:1])
        translate([i*actual_size/1.6, 0, abs(i)*size])
        sphere(d=size*2);
      } else {
        sphere(d=size*2);
      }
      
      union() {
        linear_extrude(height=fit_to_size, scale=1.15, center=true)
        offset(r=0.0625)
        base_symbol();
      }
    }
}
function adjustments(i, j, angle, offset) = (
  j==3 ? (
    i==0||i==1? [
      [-angle[0], angle[1]*0.5, angle[1]*0.875],
      [offset[0]*0.125, offset[1], offset[2]*0.75]
    ]:
    i==2? [
      [-angle[0], 0, 0],
      [0, -offset[1]*0.5, offset[2]*0.25]
    ]:
    i==3? [
      [-angle[0], -angle[1]*4, -angle[2]*1.5],
      [0, -offset[1], offset[2]*0.75]
    ]:[
      angle,
      [offset[0]*0.5, offset[1], offset[2]]
    ]
  ): i==0? [
    [angle[0]*0.75, angle[1], angle[2]*0.25],
    [offset[0], offset[1], offset[2]*1.5]
  ]: i==1? [
     [angle[0]*0.875, angle[1], angle[2]*0.75],
    [offset[0], offset[1], offset[2]*1.25]
  ]:
  [angle, offset]
);

function ensure_lift_height_ok(height, lift) = (
  height>10?
  height:
  10
);

design_a=sweep_c20563a3(height=20, sweep_angle=[45, 30], sweep_shift=[45, 30], slices=[columns, rows]);
design_b=sweep_c20563a3(height=20, sweep_angle=[45, 30], sweep_shift=[-45, 30], slices=[columns, rows]);

//translate([-80, -109, 0])
//rotate([0, 0, 90])
union() {
  for (i=[0:len(design_a)-1])
  for (j=[0:len(design_a[0])-1]) {
    base = adjustments(
      (columns-i-1),
      j,
      [
        design_a[i][j][0][1],
        design_a[i][j][0][0],
        -15
      ],
      [
        5+-j*5,
        -9+(columns-i-1)*3,
        design_a[i][j][1]+i
      ]
    ); 
    param_offset=[base[1].x, base[1].y, ensure_lift_height_ok(base[1].z, stem_lift)];
    param_angle=base[0];

    if (keyset_unit_a(i, j) == 2) {
      translate([i*19+19*0.5, j*-19, 0])
      keycap_mx_spherical_200u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.90)
      print_symbol(keyset_symbol_a(i, j), depth=2.5, cavity=0.90);
    } else if (keyset_unit_a(i, j) == 1) {
      translate([i*19, j*-19, 0])
      keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.90)
      print_symbol(keyset_symbol_a(i, j), depth=2.5, cavity=0.90);
    } else {
      // do nothing
    }
  }
}

//translate([-80, 05, 0])
//rotate([0, 0, 90])
translate([0, -90, 0])
for (i=[0:len(design_b)-1])
for (j=[0:len(design_b[0])-1]) {
  base = adjustments(
    i,
    j,
    [
      design_b[i][j][0][1],
      design_b[i][j][0][0],
      15
    ],
    [
      -5+j*5,
      -9+(i)*3,
      design_b[i][j][1]+(rows-i-1)
    ]
  );
  param_offset=[base[1].x, base[1].y, ensure_lift_height_ok(base[1].z, stem_lift)];
  param_angle=base[0];
  
  if (keyset_unit_b(i, j) == 2) {
      translate([i*19+-19*0.5, j*-19, 0])
      keycap_mx_spherical_200u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.90)
      print_symbol(keyset_symbol_b(i, j), depth=2.5, cavity=0.90);
  } else if (keyset_unit_b(i, j) == 1) {
      translate([i*19, j*-19, 0])
      keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.90)
      print_symbol(keyset_symbol_b(i, j), depth=2.5, cavity=0.90);
  } else {
      // do nothing
  }
}
