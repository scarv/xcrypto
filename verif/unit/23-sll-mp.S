
.text

test_start:

    xc.ld.hi  c0, 0xF4F3
    xc.ld.li  c0, 0xF2F1
    xc.ld.hi  c1, 0x1111
    xc.ld.li  c1, 0x1111
    xc.ld.hi  c9, 0xFFFF
    xc.ld.li  c9, 0xFFFF

    xc.ld.hi  c15, 0
    xc.ld.li  c15, 1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1

    xc.msll  (c2,c3), c0, c1, c15
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3

    xc.ld.li  c15, 2
    xc.msll  (c4,c5), c1, c0, c15
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5

    xc.ld.li  c15, 4
    xc.msll  (c6,c7), c9, c1, c15
    xc.xcr2gpr  x1, c6
    xc.xcr2gpr  x1, c7

    xc.ld.li  c15, 8
    xc.msll  (c8,c9), c0, c9, c15
    xc.xcr2gpr  x1, c8
    xc.xcr2gpr  x1, c9

    xc.ld.li  c15, 2
    xc.msll  (c2,c3), c0, c1, c15
    xc.ld.li  c15, 3
    xc.msll  (c4,c5), c1, c0, c15
    xc.ld.li  c15, 7
    xc.msll  (c6,c7), c9, c1, c15
    xc.ld.li  c15, 15
    xc.msll  (c8,c9), c0, c9, c15

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6
    xc.xcr2gpr  x1, c7
    xc.xcr2gpr  x1, c8
    xc.xcr2gpr  x1, c9

