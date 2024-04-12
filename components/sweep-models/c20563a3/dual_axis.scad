include <single_axis.scad>

function dual_axis_sweep(height, sweep_angle, sweep_shift, slices) = [
    for (a=single_axis_sweep(height=height[0], sweep_angle=sweep_angle[0], sweep_shift=sweep_shift[0], slices=the_slices)) [
        for (b=single_axis_sweep(height=height[1], sweep_angle=sweep_angle[1], sweep_shift=sweep_shift[1], slices=the_slices)) [
            [a[0], b[0]],
            [a[1], b[1]]
        ]
    ]
];
