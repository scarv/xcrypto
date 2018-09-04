
.text

test_start:

    mv2cop c0, x0
    mv2cop c1, x1
    mv2cop c2, x2
    mv2cop c3, x3

    cmov.cr c4, c0, c1
    cmov.cr c5, c1, c2
    cmov.cr c6, c2, c3
    cmov.cr c7, c3, c4
    
    mv2gpr x0, c4
    mv2gpr x1, c5
    mv2gpr x2, c6
    mv2gpr x3, c7

