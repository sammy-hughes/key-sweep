function between_inclusive(n, low, high) = n>=low && n<=high;
function loop(d, r, n) = (
  function(i)
  (function(angle)
  (function(i_sin, i_cos, x_add, y_add) [
      x_add*0.5+r*i_sin, 
      y_add*0.5+r*i_cos
    ]
  )(
    sin(angle), 
    cos(angle),
    (between_inclusive(angle, 0, 180)? +d: -d),
    (between_inclusive(angle, 90, 270)? -d: +d)
    )
  )(360/n*i)
) ;

step = loop(10, 3, 15);
echo(
    step(0), 
    step(1), 
    step(2),
    step(3), 
    step(4), 
    step(5)
);

polygon([for (i=[0:15]) step(i)]);