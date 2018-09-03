
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
    
    mv2gpr x0, c0
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

