
.text

test_start:

    xc.ld.hiu  c0, 0xF4F3
    xc.ld.liu  c0, 0xF2F1
    xc.ld.hiu  c1, 0x1111
    xc.ld.liu  c1, 0x1111
    xc.ld.hiu  c9, 0xFFFF
    xc.ld.liu  c9, 0xFFFF

    xc.msub.2  (c2,c3), c0, c1
    xc.msub.2  (c4,c5), c1, c0
    xc.msub.2  (c6,c7), c9, c1
    xc.msub.2  (c8,c9), c0, c9

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

    xc.msub.2  (c2,c3), c4, c1
    xc.msub.2  (c4,c5), c3, c2
    xc.msub.2  (c6,c7), c2, c3
    xc.msub.2  (c8,c9), c1, c4

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
