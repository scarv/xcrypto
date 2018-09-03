
.text

test_start:

    mv2cop c0, x0
    mv2cop c1, x1
    mv2cop c2, x2
    mv2cop c3, x3

    lli.cr c4, 0x1234
    lui.cr c4, 0x567a

    lui.cr c5, 0
    lli.cr c5, 0
    
    ext.cr c5, c4, 1, 4
    
    lli.cr c6, 0xFF00
    lui.cr c6, 0x0000
    ext.cr c7, c6, 4, 8

    lui.cr c8, 0
    lli.cr c8, 0
    ins.cr c8, c7, 4, 8

    mv2gpr x0, c4
    mv2gpr x1, c5
    mv2gpr x2, c6
    mv2gpr x3, c7
    mv2gpr x3, c8
