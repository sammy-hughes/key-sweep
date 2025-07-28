# key-sweep

A multi-axis, concave typing experience on your good ol' planar keyboard!

<img src="https://github.com/sammy-hughes/key-sweep/blob/main/images/dished_4x6_c20563a3.png" width="360" />

This library is an OpenSCAD keycap generator that is designed around minimal-input, multi-axis typing surfaces. The library is intended to make concave "keywell" keyboard experiences more accessible. This is accomplished by implementing the various elements of a keycap as discrete primitives which can be composed as individual "novelty" keys, universal-profile (flat) keysets, single-axis contoured keysets, or multi-axis countoured keysets.

<img src="https://github.com/sammy-hughes/key-sweep/blob/main/images/dished_3x6_split.jpg" width="360" />

progress and intended scope:

- [x] Few-parameter keycap surface control
- [x] Mechanically robust stem mounts with no hard-corner weakspots 
- [~] Vertical offsets for stems to enable keycap shrouding and low-profile keycaps
- [x] Sacrificial build-surface interfaces to negate any detriment to tolerances from auto-generated supports
- Provide flexible, parametric sweep models
    - [x] Single-lobe spherical sweep for split or left/right half ortholinear layouts
    - [x] Single-lobe, bi-modal sweep for keywell emulation on split/ortho layouts
    - [ ] Dual-lobe spherical sweep for traditional keyboards, allowing for left/right hand keywells.
    - [ ] Multi-modal sweeps with keymasks to implement offset thumb clusters or v-splits on monolithic keyboards
- Stem compatibility
    - [x] Cherry MX
    - [ ] Kailh Choc v1 (have sample keycaps)
    - [ ] Steelseries Apex
    - [ ] Alps (have sample keycaps)
- Profiles
    - [x] Spherical
    - [ ] ...does anyone like hard corners?
    - [ ] redo the current profile so it doesn't take an hour to compile?
- Symbol-sets
    - [ ] ? haven't thought this part through ?

This project is still in active development, and does not yet implement embedded legends. To achieve lettering, a text node can be linear_extrude()'ed as a child of a keycap, and it will be subtracted from the top surface. The [components/legends/legend.scad](https://github.com/sammy-hughes/keybare/blob/main/components/legends/legend.scad) file provides a controlled-size, self-scaling model, but requires a string parameter instead of taking children.
