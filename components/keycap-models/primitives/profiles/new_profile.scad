function between_inclusive(n, low, high) = n>=low && n<=high;

function square_sin(angle) = (
  between_inclusive(angle, 0, asin(0.025))? 0:
  between_inclusive(angle, asin(0.225), asin(0.275))? 1:
  between_inclusive(angle, asin(0.475), asin(0.525))? 0:
  between_inclusive(angle, asin(0.725), asin(0.775))? -1:
  between_inclusive(angle, asin(0.975), 360)? 0:
  sin(angle)
);


function square_cos(angle) = (
  between_inclusive(angle, 0, acos(0.025))? 1:
  between_inclusive(angle, acos(0.225), acos(0.275))? 0:
  between_inclusive(angle, acos(0.475), acos(0.525))? -1:
  between_inclusive(angle, acos(0.725), acos(0.775))? 0:
  between_inclusive(angle, acos(0.975), 360)? 1:
  cos(angle)
);

function points_2d(d, r, n) = (
  function(i) (
  function(angle) (
  function(i_sin, i_cos, x_add, y_add) [
      x_add*0.5+r*i_sin, 
      y_add*0.5+r*i_cos
    ]
  )(
    sin(angle),
    cos(angle),
    (between_inclusive(angle, 0, 180)? +d: -d),
    (between_inclusive(angle, 90, 270)? -d: +d)
  )
  )(360/(n-1)*i)
);

function weave(size, curve, angle, n) = (
  function(i, points) [
    for (p=points) [
      (function (result) sign(p.x)*(abs(result)+abs(p.x))*0.5) (
        p.x-(
          p.x*sin(angle.y/(n-1)*i)*(p.x>0? -1: p.x<0? +1: 0)+
          p.x*sin(curve.y/(n-1)*i)
        )*0.5
      ),
      (function (result) sign(p.y)*(abs(result)+abs(p.y))*0.5) (
        p.y-(
          p.y*sin(angle.x/(n-1)*i)*(p.y>0? -1: p.y<0? +1: 0)+
          p.y*sin(curve.x/(n-1)*i)
        )*0.5
      ),
      (function (result) result<p.z? sign(p.z)*(abs(result)+abs(p.z))*0.5: p.z) (
        p.z-
        p.z*sin(angle.y*(1-(p.x/size.x)*(p.z/size.z)))-
        p.z*sin(angle.x*(1-(p.y/size.y)*(p.z/size.z)))
        
      )
    ]
  ]
);



size=64;
step_outside=points_2d(10, 3, size);
step_inside=points_2d(9, 3, size);
for (i=[0:size-1]) {
  echo(step_outside(i));
}

function faces(length) = [
  for (i=[0:length-1]) [
    i, 
    (i<length-1? i+1: 0), 
    (i<length-1? i+1: 0), 
    i
  ]
];

points = concat(
  [for (i=[0:size-1]) concat(step_outside(i), [0])],
  [for (i=[0:size-1]) concat(step_inside(i), [0])]
);

faces = concat(
  [for (f=faces(size)) [f[0], f[1], f[2]+size*2, f[3]+size*2]],
  [for (f=faces(size)) [f[0]+size, f[1]+size, f[2]+size*3, f[3]+size*3]],
  [for (f=faces(size)) [f[0], f[1], f[2]+size, f[3]+size]],
  [for (f=faces(size)) [f[0]+size*2, f[1]+size*2, f[2]+size*3, f[3]+size*3]]
);

q_a = weave([20, 20, 6], [30, 30], [60, 60, 0], 10);
angle = [30, 30, 0];
shift = [0, 0, 10];
function sequence(n) = function(i) sin(9*i);
test = sequence(10);

echo([for (i=[0:9]) test(i)]);
for (i=[0:10-1]) {
  f = [test(i), test(i+1)];
  echo(f);
  i_angle_a = [angle.x*f[0], angle.y*f[0], angle.z*f[0]];
  i_angle_b = [angle.x*f[1], angle.y*f[1], angle.z*f[1]];
  i_shift_a = [shift.x*f[0], shift.y*f[0], shift.z*f[0]];
  i_shift_b = [shift.x*f[1], shift.y*f[1], shift.z*f[1]];
  i_points = concat(
    q_a(i, [for (i=[0:len(points)/2-1]) [
        points[i].x+i_shift_a.x, 
        points[i].y+i_shift_a.y,
        points[i].z+i_shift_a.z
      ]
    ]),
    q_a(i, [for (i=[len(points)/2:len(points)-1]) [
        points[i].x+i_shift_a.x, 
        points[i].y+i_shift_a.y,
        points[i].z+i_shift_a.z
      ]
    ]),
    
    q_a(i+1, [for (i=[0:len(points)/2-1]) [
        points[i].x+i_shift_b.x, 
        points[i].y+i_shift_b.y,
        points[i].z+i_shift_b.z
      ]
    ]),
    q_a(i+1, [for (i=[len(points)/2:len(points)-1]) [
        points[i].x+i_shift_b.x, 
        points[i].y+i_shift_b.y,
        points[i].z+i_shift_b.z
      ]
    ])
  );
  polyhedron(points=i_points, faces=faces);
}