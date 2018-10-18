
.text

test_start:

    xc.gpr2xcr c0, x0
    xc.gpr2xcr c1, x1
    xc.gpr2xcr c2, x2
    xc.gpr2xcr c3, x3

    xc.cmov c4, c0, c1
    xc.cmov c5, c1, c2
    xc.cmov c6, c2, c3
    xc.cmov c7, c3, c4

    xc.xcr2gpr x0, c4
    xc.xcr2gpr x1, c5
    xc.xcr2gpr x2, c6
    xc.xcr2gpr x3, c7

