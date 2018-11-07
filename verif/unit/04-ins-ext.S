
.text

test_start:

    xc.gpr2xcr c0, x0
    xc.gpr2xcr c1, x1
    xc.gpr2xcr c2, x2
    xc.gpr2xcr c3, x3

    xc.ld.liu c4, 0x1234
    xc.ld.hiu c4, 0x567a

    xc.ld.hiu c5, 0
    xc.ld.liu c5, 0

    xc.ext c5, c4, 2, 4

    xc.ld.liu c6, 0xFF00
    xc.ld.hiu c6, 0x0000
    xc.ext c7, c6, 4, 8

    xc.ld.hiu c8, 0
    xc.ld.liu c8, 0
    xc.ins c8, c7, 4, 8

    xc.xcr2gpr x0, c4
    xc.xcr2gpr x1, c5
    xc.xcr2gpr x2, c6
    xc.xcr2gpr x3, c7
    xc.xcr2gpr x3, c8
