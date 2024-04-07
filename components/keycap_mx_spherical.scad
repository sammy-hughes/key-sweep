include <primitives/keycap_generic.scad>;
include <primitives/post_mx.scad>;

module keycap_spherical_generic_base(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, slices=5, cavity=0.9, unit=1.00) {
    base_width=14;
    base_r=2;
    face_width=2;
    face_r=4;
    base_size = base_width+base_r*2;
    dimple_size = face_width+face_r*2;
    dimple_adjust = dimple_depth/dimple_size;
    
    keycap_generic(face_offset=face_offset, face_angle=face_angle, width=[14, 2], r=[2, 4], slices=slices, cavity=cavity, unit=unit) {
        children(0);
        hull()
        for(x=[-1:2:1])
        for(z=[0:1:1]) {
            translate([x*base_size/2, 0, z*dimple_size])
            scale([1, 1, dimple_adjust])
            sphere(d=dimple_size);
        }
        if ($children > 1)
        children([1:$children-1]);
    }
}

module keycap_mx_spherical_100u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=1.00)
    post_mx(height=face_offset.z);
    children();
}

module keycap_mx_spherical_125u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=1.25)
    post_mx(height=face_offset.z);
    children();
}

module keycap_mx_spherical_150u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=1.50)
    post_mx(height=face_offset.z);
    children();
}

module keycap_mx_spherical_175u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=1.75)
    post_mx(height=face_offset.z);
    children();
}

module keycap_mx_spherical_200u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=2.00)
    post_mx_2u(height=face_offset.z);
    children();
}

module keycap_mx_spherical_225u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=2.25)
    post_mx_2u(height=face_offset.z);
    children();
}

module keycap_mx_spherical_250u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=2.50)
    post_mx_2u(height=face_offset.z);
    children();
}

module keycap_mx_spherical_275u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=2.75)
    post_mx_2u(height=face_offset.z);
    children();
}
