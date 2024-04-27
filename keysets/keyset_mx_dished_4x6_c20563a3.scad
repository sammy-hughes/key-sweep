include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn= 90;

$FACE_WIDTH=4;
columns = 6;
rows = 3;

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
    ["", "Enter", "Fn2", "Alt", "|", "Delete"]
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
    effective_size=min(fit_to_size, actual_size);
    size_ratio=effective_size/depth;
    
    module base_symbol() {
      if (actual_size > fit_to_size) {
          text(base_symbol, size*fit_to_size/actual_size, halign="center", valign="center");
      } else {
          text(base_symbol, size, halign="center", valign="center");
      }
    }
    
    intersection() {
      if (actual_size>size) {
        hull() {
          for (i=[-1:1:1])
          translate([i*effective_size/2, 0, abs(i)*size])
          scale([size_ratio, size_ratio, 1])
          sphere(r=depth);
        }
      } else {
        scale([size_ratio, size_ratio, 1])
        sphere(r=depth);
      }
      
      union() {
        linear_extrude(height=depth*2, scale=1.15, center=true)
        offset(r=0.0625)
        base_symbol();
      }
    }
}
function adjust_column(i, a, t) = (
  [[a[0], a[1]-15, a[2]], [t[0], t[1]+(a[1]>0?-i:i), t[2]+pow(i*2, 1.5)]]
);

function adjust_row(j, a, t) = (
  [a, [t[0], t[1], t[2]]]
);
function adjust(i, j, a, t) = (
  adjust_column(i, adjust_row(j, a, t)[0], adjust_row(j, a, t)[1])
);

design=sweep_c20563a3(height=10, sweep_angle=[30, 30], sweep_shift=[0, 0], slices=[columns, rows]);
for (i=[0:len(design)-1])
for (j=[0:len(design[0])-1]) {
    result=adjust(i, j, [design[i][j][0][1], design[i][j][0][0], 0], [0, 0, 6+design[i][j][1]]);

    param_angle=result[0];
    param_offset=result[1];
    translate([i*19, j*-19, 0])
    keycap_mx_spherical_100u(
      face_offset=param_offset, 
      face_angle=[for (a=param_angle) a], 
      dimple_depth=1.25, 
      slices=30, 
      lift=6
    ) {
      print_symbol(keyset_symbol_a(i, j), depth=2, cavity=0.90);
    }
}
bogus = [
  [[30, 0, -15], [0, 0, 9+9], "delete"],
  [[15, 0, -7.5], [0, 0, 10+3], "space"],
  [[15+7.5, 15, -15], [0, 0, 9+5], "fn1"],
  [[15+15, 22.5, -7.5], [0, 0, 11+8], "do"],
];
translate([0, -60, 0]) {
    for (i=[0:3]) {
      param_angle=bogus[i][0];
      param_offset=bogus[i][1];

      translate([80-i*20, 0, 0])
      keycap_mx_spherical_100u(
        face_offset=param_offset, 
        face_angle=[for (a=param_angle) a], 
        dimple_depth=1.25, 
        slices=30, 
        cavity=0.90,
        lift=6
      ) {
        print_symbol(bogus[i][2], depth=2, cavity=0.90);
      }
    }
}
/*for (i=[0:len(design)-1])
for (j=[0:len(design[0])-1]) {
    result=adjust(i, j, [design[i][j][0][1], design[i][j][0][0], 0], [0, 0, 10+design[i][j][1]]);

    param_angle=result[0];
    param_offset=result[1];
    translate([i*19, j*-19, 0])
    keycap_mx_spherical_100u(
      face_offset=param_offset, 
      face_angle=[for (a=param_angle) a], 
      dimple_depth=1, 
      slices=30, 
      lift=6
    ) {
      print_symbol(keyset_symbol_b(i, j), depth=2.5, cavity=0.90);
    }
}*/