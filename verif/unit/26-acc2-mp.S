
.text

test_start:

    xc.ld.hiu  c0, 0x1111
    xc.ld.liu  c0, 0x1111

    xc.ld.hiu  c1, 0x2222
    xc.ld.liu  c1, 0x2222

    xc.ld.hiu  c2, 0x3333
    xc.ld.liu  c2, 0x3333

    xc.ld.hiu  c3, 0x4444
    xc.ld.liu  c3, 0x4444

    xc.ld.hiu  c9, 0xFFFF
    xc.ld.liu  c9, 0xFFFF

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1

    xc.macc.2  (c2,c3), c0, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3

    xc.macc.2  (c4,c5), c1, c0
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5

    xc.macc.2  (c6,c7), c9, c1
    xc.xcr2gpr  x1, c6
    xc.xcr2gpr  x1, c7

    xc.macc.2  (c8,c9), c0, c9
    xc.xcr2gpr  x1, c8
    xc.xcr2gpr  x1, c9

    xc.macc.2  (c2,c3), c0, c1
    xc.macc.2  (c4,c5), c1, c0
    xc.macc.2  (c6,c7), c9, c1
    xc.macc.2  (c8,c9), c0, c9

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

