include <single_axis.scad>

function dual_axis_sweep(height, sweep_angle, sweep_shift, slices) = [
    for (a=single_axis_sweep(height=[height[0], height[1]], sweep_angle=sweep_angle[0], sweep_shift=sweep_shift[0], slices=slices[0])) [
        for (b=single_axis_sweep(height=[height[0], height[1]], sweep_angle=sweep_angle[1], sweep_shift=sweep_shift[1], slices=slices[1])) [
            [a[0]*0.9+abs(b[0])*0.1*sign(a[0]), b[0]*0.9+abs(a[0])*0.1*sign(b[0])],
            height[1]+(a[1]+b[1]-height[1]*2)
        ]
    ]
];
