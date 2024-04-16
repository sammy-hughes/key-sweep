include <stepped_2_axis.scad>

function sweep_fb7958f6(height, sweep_angle, sweep_shift, slices) = (
    dual_axis_second_order_sweep(height=height, sweep_angle=sweep_angle, sweep_shift=sweep_shift, slices=slices)
);