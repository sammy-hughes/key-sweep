include <single_axis.scad>

function dual_axis_sweep(height, sweep_angle, sweep_shift, slices) = [
    for (a=single_axis_sweep(height=height*0.66, sweep_angle=sweep_angle[0], sweep_shift=sweep_shift[0], slices=slices[0])) [
        for (b=single_axis_sweep(height=height*0.66, sweep_angle=sweep_angle[1], sweep_shift=sweep_shift[1], slices=slices[1])) [
            [a[0], b[0]],
            a[1]+b[1]
        ]
    ]
];
