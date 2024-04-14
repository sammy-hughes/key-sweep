function ratio_progression(slices) = [
  for (i=[0:slices-1]) i/(slices-1)
];

function shift(sweep_shift) = (
  sweep_shift<0? 0: sweep_shift
);

function height_min(height, sweep_angle, sweep_shift) = (
  height*0.25+(height-height*sin(sweep_angle+abs(sweep_shift)))*cos(sweep_angle+abs(sweep_shift))*0.75
);

function sweep_slice(progress, sweep_shift) = (
  shift(sweep_shift)+(180-abs(sweep_shift))*progress
);

function sweep_angle(sweep_progress, sweep_angle) = (
  sweep_angle*(cos(sweep_progress)+pow(cos(sweep_progress), 3))*0.5
);

function sweep_height(sweep_progress, sweep_angle, sweep_shift,  height_max, height_min) = (
  height_min+(height_max-height_min)*pow(abs(cos(sweep_slice(sweep_progress, sweep_shift))), 3)
);

function ratio_angle_progression(progression, sweep_shift) = (
  [for (r=progression) [r, sweep_slice(r, sweep_shift)]]
);

function angle_height_progression(progression, sweep_angle, sweep_shift, height_max, height_min) = [
  for (ra=progression) [
    sweep_angle(ra[1], sweep_angle),
    sweep_height(
      ra[0], 
      sweep_angle, 
      sweep_shift, 
      height_max, 
      height_min
    )
  ]
];

function single_axis_sweep(height, sweep_angle, sweep_shift, slices) = (
  angle_height_progression(
    ratio_angle_progression(
      ratio_progression(slices), 
      sweep_shift
    ), 
    sweep_angle, 
    sweep_shift, 
    height, 
    height_min(
      height, 
      sweep_angle, 
      sweep_shift
    )
  )
);
