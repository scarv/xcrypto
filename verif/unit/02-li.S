
.text

test_start:

    xc.gpr2xcr c0, x0
    xc.gpr2xcr c1, x1
    xc.gpr2xcr c2, x2
    xc.gpr2xcr c3, x3

    xc.ld.li c4, 0x1
    xc.ld.hi c4, 0x1

    xc.ld.hi c5, 0x1
    xc.ld.li c5, 0x1

    xc.ld.li c5, 0x10
    xc.ld.hi c5, 0x10

    xc.ld.hi c6, 0xf0f0
    xc.ld.li c6, 0xf0f0

    xc.ld.hi c7, 0xFFFF
    xc.ld.li c7, 0xFFFF

    xc.xcr2gpr x0, c4
    xc.xcr2gpr x1, c5
    xc.xcr2gpr x2, c6
    xc.xcr2gpr x3, c7
