
.text

test_start:

    gpr2xcr c0, x0
    gpr2xcr c1, x1
    gpr2xcr c2, x2
    gpr2xcr c3, x3

    ld.li c4, 0x1234
    ld.hi c4, 0x567a

    ld.hi c5, 0
    ld.li c5, 0
    
    ext c5, c4, 2, 4
    
    ld.li c6, 0xFF00
    ld.hi c6, 0x0000
    ext c7, c6, 4, 8

    ld.hi c8, 0
    ld.li c8, 0
    ins c8, c7, 4, 8

    xcr2gpr x0, c4
    xcr2gpr x1, c5
    xcr2gpr x2, c6
    xcr2gpr x3, c7
    xcr2gpr x3, c8
