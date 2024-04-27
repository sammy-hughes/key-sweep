include <../c20563a3/single_axis.scad>

function dual_axis_second_order_sweep(height, sweep_angle, sweep_shift, slices) = [
    for (a=single_axis_sweep(height=height, sweep_angle=sweep_angle[0], sweep_shift=sweep_shift[0], slices=slices[0])) [
        for (b=single_axis_sweep(height=height, sweep_angle=(abs(a[0])+sweep_angle[1])*0.5, sweep_shift=sweep_shift[1], slices=slices[1])) [
            [a[0], b[0]+abs(a[0])*(b[0]>=0? 0.5: -0.5)],
            (a[1]+b[1])*0.5
        ]
    ]
];
