
.text

test_start:

    mv2cop c0, x0
    mv2cop c1, x1
    mv2cop c2, x2
    mv2cop c3, x3

    bop.cr c4, c5, c6, 0b0000
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b0001
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b0010
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b0011
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b0100
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b0101
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b0110
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b0111
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1000
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1001
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1010
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1011
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1100
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1101
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1110
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3

    bop.cr c4, c5, c6, 0b1111
    mv2gpr x4, c4
    mv2gpr x1, c1
    mv2gpr x2, c2
    mv2gpr x3, c3
