
.text

test_start:

    ld.hi  c0, 0xF4F3
    ld.li  c0, 0xF2F1
    ld.hi  c1, 0x1111
    ld.li  c1, 0x1111
    ld.hi  c9, 0xFFFF
    ld.li  c9, 0xFFFF

    add2.mp  (c2,c3), c0, c1
    add2.mp  (c4,c5), c1, c0
    add2.mp  (c6,c7), c9, c1
    add2.mp  (c8,c9), c0, c9

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9

    add2.mp  (c2,c3), c4, c1
    add2.mp  (c4,c5), c3, c2
    add2.mp  (c6,c7), c2, c3
    add2.mp  (c8,c9), c1, c4

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9
