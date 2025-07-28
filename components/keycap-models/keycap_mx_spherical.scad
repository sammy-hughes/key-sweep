include <primitives/profiles/keycap_boot.scad>
include <primitives/profiles/keycap_generic.scad>;
include <primitives/stems/cherry/stem_boot.scad>
include <primitives/stems/cherry/stem.scad>;

module keycap_spherical_generic_base(
  profile=[[$BASE_WIDTH, $FACE_WIDTH], [$BASE_R, $FACE_R]],
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=1,
  cavity=0.9,
  slices=6,
  unit=1.00,
  boot=[1, 0]
) {
  base_width=profile[0][0];
  base_r=profile[1][0];
  face_width=profile[0][1];
  face_r=profile[1][1];
  
  base_size = base_width+base_r*2;
  dimple_size = (face_width+face_r*2)*1.125;
  
  keycap_boot=boot[0];
  stem_boot=boot[1];
  
  union() {
    stem_boot(
      breadth=$STEM_CHERRY_WING_BREADTH,
      thickness=$STEM_CHERRY_WING_THICKNESS,
      lift=keycap_boot+stem_boot
    );
    keycap_boot(
      width=base_width,
      r=base_r,
      cavity=cavity,
      unit=unit,
      lift=keycap_boot
    );
  }
  
  translate([0, 0, keycap_boot])
  keycap_generic(
    face_offset=face_offset,
    face_angle=face_angle,
    width=[base_width,
    face_width],
    r=[base_r, face_r],
    cavity=cavity,
    slices=slices,
    unit=unit
  ) {
    if ($children > 0) children(0);
    hull(){
    for(x=[-1:2:1]) {
        scale([1, 1, dimple_depth/(dimple_size*0.5)])
        translate([x*(base_size-base_size*unit)*0.5, 0, dimple_size*0.5*(dimple_depth/dimple_size)])
        sphere(d=dimple_size-$DIMPLE_INSET*2);
      }
    }
    
    if ($children > 1) children([1:$children-1]);
  }
}

module test_dimple() {
  $fn=90;
  base_size = 16+2;
  dimple_size = (9+8)*0.5;
  dimple_depth=1.75;
  scale([1, 1, dimple_depth/(dimple_size*0.5)])
  translate([0, 0, dimple_size*0.5*(dimple_depth/dimple_size)])
  sphere(d=dimple_size*1.125);
}

module keycap_mx_spherical_100u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    slices=slices,
    unit=1.00,
    boot=boot
  ) {
    stem_cherry_1u(height=face_offset.z, lift=boot[1]);
    children();
  }
}

module keycap_mx_spherical_125u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    slices=slices,
    unit=1.25,
    boot=boot
  ) {
    stem_cherry_1u(height=face_offset.z, lift=boot[1]);
    children();
  }
}

module keycap_mx_spherical_150u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    slices=slices,
    unit=1.50,
    boot=boot
  ) {
    stem_cherry_1u(height=face_offset.z, lift=boot[1]);
    children();
  }
}

module keycap_mx_spherical_175u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    slices=slices,
    unit=1.75,
    boot=boot
  ) {
    stem_cherry_1u(height=face_offset.z, lift=boot[1]);
    children();
  }
}

module keycap_mx_spherical_200u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    slices=slices,
    unit=2.00,
    boot=boot
  ) {
    stem_cherry_2u(height=face_offset.z, lift=boot[1]);
    children();
  }
}

module keycap_mx_spherical_225u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    slices=slices,
    unit=2.25,
    boot=boot
  ) {
    stem_cherry_2u(height=face_offset.z, lift=boot[1]);
    children();
  }
}

module keycap_mx_spherical_250u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    slices=slices,
    unit=2.50,
    boot=boot
  ) {
    stem_cherry_2u(height=face_offset.z, lift=boot[1]);
    children();
  }
}

module keycap_mx_spherical_275u(
  face_offset=[0, 0, 5],
  face_angle=[0, 0, 0],
  dimple_depth=0.5,
  cavity=0.9,
  slices=6,
  boot=[0, 0]
) {
  keycap_spherical_generic_base(
    face_offset=face_offset,
    face_angle=face_angle,
    dimple_depth=dimple_depth,
    cavity=cavity,
    unit=2.75,
    boot=boot
  ) {
    stem_cherry_2u(height=face_offset.z, lift=boot[1]);
    children();
  }
}
