
.text

test_start:

    gpr2xcr c0, x0
    gpr2xcr c1, x1
    gpr2xcr c2, x2
    gpr2xcr c3, x3

    ld.li c4, 0x1
    ld.hi c4, 0x1
    
    ld.hi c5, 0x1
    ld.li c5, 0x1

    ld.li c5, 0x10
    ld.hi c5, 0x10
    
    ld.hi c6, 0xf0f0
    ld.li c6, 0xf0f0
    
    ld.hi c7, 0xFFFF
    ld.li c7, 0xFFFF
    
    xcr2gpr x0, c4
    xcr2gpr x1, c5
    xcr2gpr x2, c6
    xcr2gpr x3, c7
