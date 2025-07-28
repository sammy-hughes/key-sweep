function step(n, i, s=0) = (i-(n-1)*0.5)/((n-1)*0.5);
function sin_extend(a) = abs(a)>90?round(a/90)+sin(a%90):sin(a);
function asin_extend(r) = abs(r)>1?90*round(r)+asin(r%1):asin(r);
function bias_ratio(a, s) = a==0||s==0?1:abs(abs(a)>abs(s)?s/a:a/s)*sign(s);
function bias_degrees(r, a, s) = abs(s*bias_ratio(a, s))*(abs(r*a)>abs(s)?sign(r):sign(s));
function ratio_range(a, s) = 90-(90-abs(a)*1-abs(s)*1);
function ratio_degrees(r, a, s) = asin_extend(r)*(ratio_range(a, s)/90)+bias_degrees(r, a, s);
function ratio_sin(r, e=1, a=0, s=0) = abs(pow(sin_extend(ratio_degrees(r, a, s)), e))*sign(r);
function step_smooth_1(n, i) = (
  i==0?
    [0, 1]:
  i==n-1?
    [n-2, n-1]:
  [i-1, i+1]
);
function step_smooth_2(n, i) = (
  i==0?
    [0, 0, 0]:
  i==n-1?
    [n-1, n-1, n-1]:
  [i-1, i, i+1]
);
function step_smooth_3(n, i) = (
  i==0?
    [0, 0, 1]:
  i==1?
    [1, 1, 2]:
  i==n-2?
    [n-3, n-2, n-2]:
  i==n-1?
    [n-2, n-1, n-1]:
  [i-1, i, i+1]
);
function step_angle(n, a, s, i) = -ratio_sin(step(n, i), e=1, a=a, s=s);
function step_height(n, a, s, i) = abs(ratio_sin(step(n, i), e=1, a=a, s=s));
function step_angle_smoothed(n, a, s, i) = (function(p) (step_angle(n, a, s, p.x)*0.33+step_angle(n, a, s, p.y)*0.33+step_angle(n, a, s, p.z)*0.33))(step_smooth_2(n, i));
function step_height_smoothed(n, a, s, i) = (function(p) (step_height(n, a, s, p.x)*0.25+step_height(n, a, s, p.y)*0.5+step_height(n, a, s, p.z)*0.25))(step_smooth_2(n, i));

echo(step_angle(6, 30, 15, 1));
echo(step_angle_smoothed(6, 30, 15, 1));

function single_axis_sweep(height, sweep_angle, sweep_shift, slices) = [
  for (i=[0:slices-1]) [
    step_angle_smoothed(slices, sweep_angle, sweep_shift, i)*sweep_angle,
    step_height_smoothed(slices, sweep_angle, sweep_shift, i)*(height[0]-height[1])+height[1]
  ]
];

module test_sweep() {
  testcases = [
    // [height, sweep_angle, sweep_shift, slices]
    [[12, 4], 0, 0, 6],
    [[12, 4], 15, 0, 6],
    [[12, 4], 0, 0, 4],
    [[12, 4], 15, 0, 4],
    [[12, 4], 15, 0, 6],
    [[12, 4], 15, 30, 6],
    [[12, 4], 15, -30, 6],
    [[12, 4], 15, 0, 4],
    [[12, 4], 15, 30, 4],
    [[12, 4], 15, -30, 4],
    [[12, 4], 30, 0, 6],
    [[12, 4], 30, 45, 6],
    [[12, 4], 30, -45, 6],
    [[12, 4], 45, 0, 6],
    [[12, 4], 45, 15, 6],
    [[12, 4], 45, -15, 6],
    [[12, 4], 45, 0, 4],
    [[12, 4], 45, 15, 4],
    [[12, 4], 45, -15, 4],
    [[12, 4], 45, 0, 3],
    [[12, 4], 45, 15, 3],
    [[12, 4], 45, -15, 3]
  ];
  
  module case_render(i, scenario) {
    size=2;
    
    function case_i(i) = str("Case ", i);
    function case_height(scenario) = str("[max, min]=", scenario[0]);
    function case_angle(scenario) = str("angle=", scenario[1]);
    function case_shift(scenario) = str("shift=", scenario[2]);
    function case_slices(scenario) = str("slices=", scenario[3]);
    
    header = [
      case_i(i),
      case_height(scenario),
      case_angle(scenario),
      case_shift(scenario),
      case_slices(scenario)
    ];
    
    rotate([0, 0, 90])
    translate([-10, len(header)*size, 0])
    linear_extrude(1)
    for (i=[0:len(header)-1])
    translate([0, -size*i, 0])
    text(header[i], size=size);
  }
  
  module sweep_render(result) {
    size=2;
    
    function sweep_translation(result) = str("translate([0, 0, ", result[1], "])");
    function sweep_rotation(result) = str("rotate(", result[0], ")");
    
    translate([0, 10, 0])
    rotate([45, 0, 90]) {
      linear_extrude(height=1)
      text(sweep_translation(result), size=size, valign="center");
      translate([0, size*1.5, 0])
      linear_extrude(height=1)
      text(sweep_rotation(result), size=size, valign="center");
    }
  }
  
  for (i=[0:len(testcases)-1]) {
    translate([0, 50*i, 0]) {
      scenario = testcases[i];
      case_render(i, scenario);
      
      height=scenario[0];
      sweep_angle=scenario[1];
      sweep_shift=scenario[2];
      slices=scenario[3];
      sweep=single_axis_sweep(height=height, sweep_angle=sweep_angle, sweep_shift=sweep_shift, slices=slices);
      
      translate([20, 0, 0])
      for (j=[0:slices-1]) {
        result = sweep[j];
        echo("result", i, j, result, result[0], result[1]);
        translate([20*j, 0, 0])
        sweep_render(result);
        
        translate([20*j, 0, result[1]])
        rotate([0, result[0], 0])
        cube([19, 19, 1], center=true);
      }
    }
  }
}

// test_sweep();