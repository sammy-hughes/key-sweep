include <single_axis.scad>

function dual_axis_sweep(height=[5, 10], sweep_angle=[45, 45], sweep_shift=[0, 0], slices=[3, 6]) = [
    for (a=single_axis_sweep(height[0], slices[0], sweep_angle[0], sweep_shift[0])) [
        for (b=single_axis_sweep(height[1], slices[1], sweep_angle[1], sweep_shift[1])) [
            [a[0], b[0]],
            [a[1], b[1]]
        ]
    ]
];
