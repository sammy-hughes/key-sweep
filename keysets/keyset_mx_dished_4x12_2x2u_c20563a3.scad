include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn=90;
$BASE_WIDTH=15;
$BASE_R=1.5;
$FACE_WIDTH=4;
$FACE_R=3.6;
columns = 6;
rows = 4;
stem_lift=1.4;

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
module print_symbol(base_symbol, size=4, depth=0.5, fit_to_size=16, cavity=0.9) {
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
      [-angle[0]*0.5, angle[1], angle[1]*0.5],
      [-offset[0], offset[1]*2, offset[2]*0.75]
    ]:
    i==2? [
      [-angle[0]*0.5, 0, -angle[2]],
      [-offset[0]*1.25, -offset[1], offset[2]*0.5]
    ]:
    i==3? [
      [-angle[0]*1, -angle[1]*4, -angle[2]*1.75],
      [-offset[0]*0.50, -offset[1]*2.5, offset[2]*0.75]
    ]:// n
    i==4? [
      [-angle[0]*1.75, angle[1]*22.5, -angle[2]*5],
      [ offset[0]*1.25, -offset[1]*7, offset[2]*1.75]
    ]:
    [angle, offset]
  ): i==2||i==3? [
    [angle[0]*0.75, angle[1], angle[2]],
    [offset[0], offset[1]*1.25, offset[2]*0.80]
  ]: i==0? [
    [angle[0]*0.75, angle[1]*1.25, angle[2]*0.75],
    [0, offset[1]*1.25, offset[2]*1.25]
  ]:
  [angle, offset]
);

function ensure_lift_height_ok(height, lift) = (
  height>8?
  height:
  8
);

design_a=sweep_c20563a3(height=20, sweep_angle=[37.5, 37.5], sweep_shift=[52.5, 0], slices=[columns, rows]);
design_b=sweep_c20563a3(height=20, sweep_angle=[37.5, 37.5], sweep_shift=[-52.5, 0], slices=[columns, rows]);

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
        -((columns-i-1)*3)
      ],
      [
        -(columns-i-1)*1+-(rows-j-1)*0.125, 
        -3+(columns-i-1)*1+(rows-j-1)*0.25,
        design_a[i][j][1]
      ]
    );
    param_offset=[base[1].x, base[1].y, ensure_lift_height_ok(base[1].z, stem_lift)];
    param_angle=base[0];

    if (keyset_unit_a(i, j) == 2) {
      translate([i*19+19*0.5, j*-19, 0])
      keycap_mx_spherical_200u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.85)
      print_symbol(keyset_symbol_a(i, j), depth=2.5, cavity=0.85);
    } else if (keyset_unit_a(i, j) == 1) {
      translate([i*19, j*-19, 0])
      keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.85)
      print_symbol(keyset_symbol_a(i, j), depth=2.5, cavity=0.85);
    } else {
      // do nothing
    }
  }
}

//translate([-80, 05, 0])
//rotate([0, 0, 90])
translate([0, -84, 0])
for (i=[0:len(design_b)-1])
for (j=[0:len(design_b[0])-1]) {
  base = adjustments(
    i,
    j,
    [
      design_b[i][j][0][1],
      design_b[i][j][0][0],
      (i*3)
    ],
    [
      (i)*0.75+(rows-j-1)*0.125, 
      -3+(i)*1+(rows-j-1)*0.25,
      design_b[i][j][1]
    ]
  );
  param_offset=[base[1].x, base[1].y, ensure_lift_height_ok(base[1].z, stem_lift)];
  param_angle=base[0];
  
  if (keyset_unit_b(i, j) == 2) {
      translate([i*19+-19*0.5, j*-19, 0])
      keycap_mx_spherical_200u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.85)
      print_symbol(keyset_symbol_b(i, j), depth=2.5, cavity=0.85);
  } else if (keyset_unit_b(i, j) == 1) {
      translate([i*19, j*-19, 0])
      keycap_mx_spherical_100u(face_offset=param_offset, face_angle=param_angle, dimple_depth=1, slices=30, lift=stem_lift, cavity=0.85)
      print_symbol(keyset_symbol_b(i, j), depth=2.5, cavity=0.85);
  } else {
      // do nothing
  }
}
