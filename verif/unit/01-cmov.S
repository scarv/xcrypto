
.text

test_start:

    gpr2xcr c0, x0
    gpr2xcr c1, x1
    gpr2xcr c2, x2
    gpr2xcr c3, x3

    cmov c4, c0, c1
    cmov c5, c1, c2
    cmov c6, c2, c3
    cmov c7, c3, c4
    
    xcr2gpr x0, c4
    xcr2gpr x1, c5
    xcr2gpr x2, c6
    xcr2gpr x3, c7

