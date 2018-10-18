
.text

test_start:

    mv2cop c0, x0
    mv2cop c1, x1
    mv2cop c2, x2
    mv2cop c3, x3

    lli.cr c4, 0x1
    lui.cr c4, 0x1
    
    lui.cr c5, 0x1
    lli.cr c5, 0x1

    lli.cr c5, 0x10
    lui.cr c5, 0x10
    
    lui.cr c6, 0xf0f0
    lli.cr c6, 0xf0f0
    
    lui.cr c7, 0xFFFF
    lli.cr c7, 0xFFFF
    
    xcr2gpr x0, c4
    xcr2gpr x1, c5
    xcr2gpr x2, c6
    xcr2gpr x3, c7
