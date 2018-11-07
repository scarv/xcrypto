
.text

test_start:

    xc.gpr2xcr c0, x0
    xc.gpr2xcr c1, x1
    xc.gpr2xcr c2, x2
    xc.gpr2xcr c3, x3

    xc.ld.liu c4, 0x1
    xc.ld.hiu c4, 0x1

    xc.ld.hiu c5, 0x1
    xc.ld.liu c5, 0x1

    xc.ld.liu c5, 0x10
    xc.ld.hiu c5, 0x10

    xc.ld.hiu c6, 0xf0f0
    xc.ld.liu c6, 0xf0f0

    xc.ld.hiu c7, 0xFFFF
    xc.ld.liu c7, 0xFFFF

    xc.xcr2gpr x0, c4
    xc.xcr2gpr x1, c5
    xc.xcr2gpr x2, c6
    xc.xcr2gpr x3, c7
