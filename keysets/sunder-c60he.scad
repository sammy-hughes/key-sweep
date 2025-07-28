include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;
include <../components/legends/legend.scad>;

$fn=90;
$unit=19.05;
$symbol_depth=3.25;
$dimple_depth=1.75;
$boot_keycap=2.00;
$boot_stem=3.2;

// effective height = real_height - dimple_depth + real_width*sin(face_angle)
$max_height=13;
$min_height=5.0;
$thumb_height=11.0;

// left==1
// right==2
// both==3
$sidemask=3;

columns = 7;
rows = 3;

keyset_symbol_source_a = [
  ["tab", "Q", "W", "E", "R", "T", "^"],
  ["OS", "A", "S", "D", "F", "G", "alt"],
  ["shift", "Z", "X", "C", "V", "B", "exit"],
  ["F1", "F2", "F3", "F4", "F5", "F6"]
];
keyset_symbol_source_b = [
  ["^", "Y", "U", "I", "O", "P", "+"],
  ["ctrl", "H", "J", "K", "L", ";", "'"],
  ["delete", "N", "M", "<", ">", "?", "-"],
  ["F7", "F8", "F9", "F10", "F11", "F12"]
];

function keyset_symbol_a(i, j) = (
  keyset_symbol_source_a[j][i]
);

function keyset_symbol_b(i, j) = (
  keyset_symbol_source_b[j][i]
);

// Sweep used to define individual key parameters
design_a=sweep_c20563a3(height=[$max_height, $min_height], sweep_angle=[30, 30], sweep_shift=[30, -22.5], slices=[columns, rows]);
design_b=sweep_c20563a3(height=[$max_height, $min_height], sweep_angle=[30, 30], sweep_shift=[-30, -22.5], slices=[columns, rows]);

function reach_fn_row(i, height=0) = [3.75-i*1.5, -4, height];
function angle_fn_row(i, a=[0, 0]) = [-a[1]*0.5, a[0]*0.75, 0];

function reach_matrix(i, j, height=0) = [3.75-i*1.5, -3+j*3, height];
function angle_matrix(i, j, a=[0, 0]) = [a[1], a[0], 0];

module left_hand() {
  module fn_row() {
    for (i=[0:5]) {
      echo(i, reach_fn_row(i, design_a[i][0][1]), angle_fn_row(i, design_a[i][0][0]));
      translate([i*$unit, 0, 0])
      keycap_mx_spherical_100u(
        face_offset=reach_fn_row(i, design_a[i][0][1]), 
        face_angle=angle_fn_row(i, design_a[i][0][0]), 
        dimple_depth=$dimple_depth,
        cavity=$KEY_CAVITY,
        slices=$SLICES, 
        boot=[$boot_keycap, $boot_stem]
      ) {
        print_symbol(keyset_symbol_a(i, 3), depth=$symbol_depth, cavity=$SYMBOL_CAVITY);
      }
    }
  }
  
  module matrix() {
    for (i=[0:len(design_a)-1])
    for (j=[0:len(design_a[0])-1]) {
      echo(i, j, reach_matrix(i, j, design_a[i][j][1]), angle_matrix(i, j, design_a[i][j][0]));
      translate([i*$unit, j*-$unit, 0])
      keycap_mx_spherical_100u(
        face_offset=reach_matrix(i, j, design_a[i][j][1]),
        face_angle=angle_matrix(i, j, design_a[i][j][0]), 
        dimple_depth=$dimple_depth,
        cavity=$KEY_CAVITY,
        slices=$SLICES, 
        boot=[$boot_keycap, $boot_stem]
      ) {
        print_symbol(keyset_symbol_a(i, j), depth=$symbol_depth, cavity=$SYMBOL_CAVITY);
      }
    }
  }
  
  module thumbs() {
    thumb_cluster_a = [
      [0, "do"],
      [0, "fn1"],
      [0, "space"],
    ];

    for (i=[0:2]) {
      translate([$unit*4+i*$unit, 0, 0])
      keycap_mx_spherical_100u(
        face_offset=reach_matrix(i, 0, design_a[i][0][1]), 
        face_angle=angle_matrix(i, 0, design_a[i][0][0]), 
        dimple_depth=$dimple_depth, 
        slices=$SLICES,
        cavity=$KEY_CAVITY,
        boot=[$boot_keycap, $boot_stem]
      ) {
        print_symbol(thumb_cluster_a[i][1], depth=$symbol_depth, cavity=$SYMBOL_CAVITY);
      }
    }
  }
    
  fn_row();
  translate([0, -$unit, 0])
  matrix();
  translate([0, -$unit*4, 0])
  thumbs();
}

module right_hand() {
  module fn_row() {
    for (i=[5:-1:0]) {
      translate([i*$unit, 0, 0])
      keycap_mx_spherical_100u(
        face_offset=reach_fn_row(i, design_b[i][0][1]), 
        face_angle=angle_fn_row(i, design_b[i][0][0]), 
        dimple_depth=$dimple_depth,
        cavity=$KEY_CAVITY,
        slices=$SLICES, 
        boot=[$boot_keycap, $boot_stem]
      ) {
        print_symbol(keyset_symbol_b(i, 3), depth=$symbol_depth, cavity=$SYMBOL_CAVITY);
      }
    }
  }
  
  module matrix() {
    for (i=[len(design_b)-1:-1:0])
    for (j=[len(design_b[0])-1:-1:0]) {
      translate([i*$unit, j*-$unit, 0])
      keycap_mx_spherical_100u(
        face_offset=reach_matrix(i, j, design_b[i][j][1]),
        face_angle=angle_matrix(i, j, design_b[i][j][0]), 
        dimple_depth=$dimple_depth,
        cavity=$KEY_CAVITY,
        slices=$SLICES, 
        boot=[$boot_keycap, $boot_stem]
      ) {
        print_symbol(keyset_symbol_b(i, j), depth=$symbol_depth, cavity=$SYMBOL_CAVITY);
      }
    }
  }

  module thumbs() {
    thumb_cluster_b = [
      [0, "alt"],
      [0, "fn2"],
      [0, "enter"],
    ];

    for (i=[0:2]) {
      translate([$unit*2-i*$unit, 0, 0])
      keycap_mx_spherical_100u(
        face_offset=reach_matrix(columns-1-i, 0, design_b[columns-1-i][0][1]), 
        face_angle=angle_matrix(columns-1-i, 0, design_b[columns-1-i][0][0]), 
        dimple_depth=$dimple_depth,
        slices=$SLICES,
        cavity=$KEY_CAVITY,
        boot=[$boot_keycap, $boot_stem]
      ) {
        print_symbol(thumb_cluster_b[i][1], depth=$symbol_depth, cavity=$SYMBOL_CAVITY);
      }
    }
  }

  translate([$unit, 0, 0])
  fn_row();
  translate([0, -$unit, 0])
  matrix();
  translate([0, -$unit*4, 0])
  thumbs();
}

if ($sidemask == 1) {
  translate([-$unit*3, 0, 0])
  left_hand();
} else if ($sidemask == 2) {
  translate([-$unit*3, 0, 0])
  right_hand();
} else {
  translate([-$unit*6.5, 0, 0])
  left_hand();
  translate([$unit*0.5, 0, 0])
  right_hand();
}
