
.text

test_start:

    gpr2xcr c0, x0
    gpr2xcr c1, x1
    gpr2xcr c2, x2
    gpr2xcr c3, x3

    lli.cr c4, 0x1234
    lui.cr c4, 0x567a

    lui.cr c5, 0
    lli.cr c5, 0
    
    ext.cr c5, c4, 2, 4
    
    lli.cr c6, 0xFF00
    lui.cr c6, 0x0000
    ext.cr c7, c6, 4, 8

    lui.cr c8, 0
    lli.cr c8, 0
    ins.cr c8, c7, 4, 8

    xcr2gpr x0, c4
    xcr2gpr x1, c5
    xcr2gpr x2, c6
    xcr2gpr x3, c7
    xcr2gpr x3, c8
