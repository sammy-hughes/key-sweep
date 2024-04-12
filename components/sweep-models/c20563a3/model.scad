include <single_axis.scad>

function sweep_c20563a3(height=[5, 10], sweep_angle=[45, 45], sweep_shift=[0, 0], slices=[3, 6]) = (
    dual_axis_sweep(height, sweep_angle, sweep_shift, slices)
);
