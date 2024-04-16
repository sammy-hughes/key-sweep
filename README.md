# key-sweep

A multi-axis, concave typing experience on your good ol' planar keyboard!

![they feel much nicer than they look!](https://github.com/sammy-hughes/key-sweep/blob/main/images/dished_3x6_split.jpg)

This library is an OpenSCAD keycap generator that is designed around minimal-input, multi-axis typing surfaces. The library is intended to make concave "keywell" keyboard experiences more accessible. This is accomplished by implementing the various elements of a keycap as discrete primitives which can be composed as individual "novelty" keys, universal-profile (flat) keysets, single-axis contoured keysets, or multi-axis countoured keysets.

Currently only the Cherry MX stem system is implemented, but this project has in-scope the following mounting systems:

- [x] Cherry MX
- [ ] Kailh Choc v1
- [ ] Steelseries Apex
- [ ] Alps

This project is still in active development, and does not yet implement embedded symbols. To achieve lettering, a text node can be linear_extrud()'ed as a child of a keycap, and it will be subtracted from the top surface. No off-the-shelf elements are yet provided, though, and it is not yet clear what the target API would look like.
