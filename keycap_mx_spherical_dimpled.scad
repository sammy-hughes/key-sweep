include <keycap_generic.scad>;
include <post_mx.scad>;

module keycap_mx_spherical_dimpled(face_offset=[0, 0, 30], face_angle=[37.5, 0, 0]) {
    keycap_generic(width=[14, 2], r=[2, 4], slices=15, face_offset=face_offset, face_angle=face_angle) {
        post_mx();
        translate([0, 0, 47])
        scale([1, 1, 0.5])
        sphere(d=96);
    }
}
