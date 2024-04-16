include <../primitives/profiles/keycap_generic.scad>;
include <../primitives/stems/cherry/stem.scad>;

$BASE_WIDTH=14;
$FACE_WIDTH=2;
$BASE_R=2;
$FACE_R=5;
$_PROFILE=[[$BASE_WIDTH, $FACE_WIDTH], [$BASE_R, $FACE_R]];

module keycap_spherical_generic_base(profile=$_PROFILE, face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=1, cavity=0.9, slices=6, unit=1.00) {
    base_width=profile[0][0];
    base_r=profile[1][0];
    face_width=profile[0][1];
    face_r=profile[1][1];
    
    base_size = base_width+base_r*2;
    dimple_size = base_size*2;
    keycap_generic(face_offset=face_offset, face_angle=face_angle, width=[base_width, face_width], r=[base_r, face_r], cavity=cavity, slices=slices, unit=unit) {
        if ($children > 0) children(0);
        hull(){
        for(x=[-1:2:1]) {
                translate([x*(base_size-base_size*unit/1)*0.5, 0, dimple_size-dimple_depth])
                sphere(r=dimple_size);
            }
        }
        
        if ($children > 1) children([1:$children-1]);
    }
}

module keycap_mx_spherical_100u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, slices=slices, unit=1.00)
    stem_cherry_1u(height=face_offset.z, lift=lift);
    children();
}

module keycap_mx_spherical_125u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, slices=slices, unit=1.25)
    stem_cherry_1u(height=face_offset.z, lift=lift);
    children();
}

module keycap_mx_spherical_150u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, slices=slices, unit=1.50)
    stem_cherry_1u(height=face_offset.z, lift=lift);
    children();
}

module keycap_mx_spherical_175u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, slices=slices, unit=1.75)
    stem_cherry_1u(height=face_offset.z, lift=lift);
    children();
}

module keycap_mx_spherical_200u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, slices=slices, unit=2.00)
    stem_cherry_2u(height=face_offset.z, lift=lift);
    children();
}

module keycap_mx_spherical_225u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, slices=slices, unit=2.25)
    stem_cherry_2u(height=face_offset.z, lift=lift);
    children();
}

module keycap_mx_spherical_250u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, slices=slices, unit=2.50)
    stem_cherry_2u(height=face_offset.z, lift=lift);
    children();
}

module keycap_mx_spherical_275u(face_offset=[0, 0, 5], face_angle=[0, 0, 0], dimple_depth=0.5, cavity=0.9, slices=6, lift=0) {
    keycap_spherical_generic_base(face_offset=face_offset, face_angle=face_angle, dimple_depth=dimple_depth, cavity=cavity, unit=2.75)
    stem_cherry_2u(height=face_offset.z, lift=lift);
    children();
}
