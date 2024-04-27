include <../components/keycap-models/keycap_mx_spherical.scad>;
include <../components/sweep-models/c20563a3/model.scad>;

$fn=90;

$FACE_WIDTH=4;
$FACE_R=5;
columns = 6;
rows = 3;

keyset_symbol_source_a = [
  ["tab", "Q", "W", "E", "R", "T"],
  ["OS", "A", "S", "D", "F", "G"],
  ["shift", "Z", "X", "C", "V", "B"],
  ["F1", "F2", "F3", "F4", "F5", "F6"]
];
keyset_symbol_source_b = [
  ["Y", "U", "I", "O", "P", "+"],
  ["H", "J", "K", "L", ";", "'"],
  ["N", "M", "<", ">", "?", "-"],
  ["F7", "F8", "F9", "F10", "F11", "F12"]
];

function keyset_symbol_a(i, j) = (
  keyset_symbol_source_a[j][i]
);
function keyset_symbol_b(i, j) = (
  keyset_symbol_source_b[j][i]
);
module print_symbol(base_symbol, size=4, depth=2.25, fit_to_size=13, cavity=0.9) {
  actual_size = len(base_symbol)*size;
  effective_size=min(fit_to_size, actual_size);
  size_ratio=effective_size/depth;
  
  module base_symbol() {
    scale_factor=(actual_size > fit_to_size? fit_to_size/actual_size: 1);
    
    scale([scale_factor, scale_factor, scale_factor])
    offset(r=size*0.0625)
    offset(delta=size*-0.03125)
    text(base_symbol, size, halign="center", valign="center");
  }
  
  intersection() {
    linear_extrude(height=depth*2, scale=1.05, center=true)
    base_symbol();
    
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
  }
}
function adjust_column(i, a, t) = (
  [
    [a[0], a[1], a[2]], 
    [
      t[0]+pow(abs(i-(columns-1)*0.5),2)*(
        a[1]>0? 1:
        a[1]<0? -1:
        0
      ), 
      t[1],
      t[2]
    ]
  ]
);
echo(pow(-3,3));
function adjust_row(j, a, t) = (
  [
    a, 
    [
      t[0], 
      t[1]+(
        j==-1? 1.25:
        j==0? -1.5: 
        j==1? -0.25:
        j==2? +0.875: 
        0
      )*4,
      t[2]+(
        j==-1?+1.5:
        j==0? +0.5:
        j==1? +1.125:
        j==2? +0.875:
        0
      )*2
    ]
  ]
);
function adjust(i, j, a, t) = (
  adjust_column(i, adjust_row(j, a, t)[0], adjust_row(j, a, t)[1])
);

design=sweep_c20563a3(height=10, sweep_angle=[15, 30], sweep_shift=[0, -45], slices=[columns, rows]);
translate([3, 0, 0])
for (i=[0:5]) {
  result=adjust(i, -1, [-design[i][0][0][1]*0.5, design[i][0][0][0]*0.75, 0], [0, 0, design[i][0][1]-1]);
  param_angle=result[0];
  param_offset=[result[1].x, -(result[1].y*0.875+3), result[1].z];
  translate([i*19, 0, 0])
  keycap_mx_spherical_100u(
    face_offset=param_offset, 
    face_angle=[for (a=param_angle) a], 
    dimple_depth=0.25,
    cavity=0.85,
    slices=10, 
    lift=0
  ) {
    print_symbol(keyset_symbol_a(i, 3), depth=0.75, cavity=0.85);
  }
}
translate([3, -19, 0]) {
  for (i=[0:len(design)-1])
  for (j=[0:len(design[0])-1]) {
    result=adjust(i, j, [design[i][j][0][1], design[i][j][0][0], 0], [0, 0, design[i][j][1]+0.25]);

    param_angle=result[0];
    param_offset=result[1];
    translate([i*19, j*-19, 0])
    keycap_mx_spherical_100u(
      face_offset=param_offset, 
      face_angle=[for (a=param_angle) a], 
      dimple_depth=1.05,
      cavity=0.85,
      slices=10, 
      lift=0
    ) {
      print_symbol(keyset_symbol_a(i, j), depth=1.725, cavity=0.85);
    }
  }
  thumb_cluster_a = [
    [[-7.5, 7.5, 0], [-4, -2, 9], "escape"],
    [[7.5, 7.5, 0], [-4, 2, 9], "space"],
    [[7.5, 7.5, 0], [-2, 4, 9], "fn1"],
    [[7.5, -7.5, 0], [2, 4, 9], "do"],
  ];
  translate([0, -57, 0]) {
    for (i=[0:3]) {
      param_angle=thumb_cluster_a[i][0];
      param_offset=thumb_cluster_a[i][1];

      translate([80-i*19, 0, 0])
      keycap_mx_spherical_100u(
        face_offset=param_offset, 
        face_angle=[for (a=param_angle) a], 
        dimple_depth=0.75, 
        slices=10, 
        cavity=0.85,
        lift=0
      ) {
      print_symbol(thumb_cluster_a[i][2], depth=1.75, cavity=0.85);
      }
    }
  }
}
translate([-3, -95, 0]) {
  for (i=[0:5]) {
    result=adjust((columns-i-1), -1, [-design[i][0][0][1]*0.5, design[i][0][0][0]*0.75, 0], [0, 0, design[i][0][1]-1]);
    param_angle=result[0];
    param_offset=[result[1].x, -(result[1].y*0.875+3), result[1].z];
    translate([i*19, 0, 0])
    keycap_mx_spherical_100u(
      face_offset=param_offset, 
      face_angle=[for (a=param_angle) a], 
      dimple_depth=0.25,
      cavity=0.85,
      slices=10, 
      lift=0
    ) {
      print_symbol(keyset_symbol_b(i, 3), depth=0.75, cavity=0.85);
    }
  }
}
translate([-3, -114, 0]) {
  for (i=[0:len(design)-1])
  for (j=[0:len(design[0])-1]) {
    result=adjust((columns-i-1), j, [design[i][j][0][1], design[i][j][0][0], 0], [0, 0, design[i][j][1]+0.25]);

    param_angle=result[0];
    param_offset=result[1];
    translate([i*19, j*-19, 0])
    keycap_mx_spherical_100u(
      face_offset=param_offset, 
      face_angle=[for (a=param_angle) a], 
      dimple_depth=1.05,
      cavity=0.85,
      slices=10, 
      lift=0
    ) {
      print_symbol(keyset_symbol_b(i, j), depth=1.725, cavity=0.85);
    }
  }
}

thumb_cluster_b = [
  [[-7.5, -7.5, 0], [4, -2, 9], "delete"],
  [[7.5, -7.5, 0], [4, 2, 9], "enter"],
  [[7.5, -7.5, 0], [2, 4, 9], "fn2"],
  [[7.5, 7.5, 0], [-2, 4, 9], "alt"],
];
translate([0, -171, 0]) {
  for (i=[0:3]) {
    param_angle=thumb_cluster_b[i][0];
    param_offset=thumb_cluster_b[i][1];

    translate([20+i*19, 0, 0])
    keycap_mx_spherical_100u(
      face_offset=param_offset, 
      face_angle=[for (a=param_angle) a], 
      dimple_depth=0.75, 
      slices=10,
      cavity=0.85,
      lift=0
    ) {
      print_symbol(thumb_cluster_b[i][2], depth=1.75, cavity=0.85);
    }
  }
}
