
.text

test_start:

    gpr2xcr c0, x0
    gpr2xcr c1, x1
    gpr2xcr c2, x2
    gpr2xcr c3, x3

    bop c4, c5, c6, 0b0000
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b0001
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b0010
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b0011
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b0100
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b0101
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b0110
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b0111
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1000
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1001
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1010
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1011
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1100
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1101
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1110
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3

    bop c4, c5, c6, 0b1111
    xcr2gpr x4, c4
    xcr2gpr x1, c1
    xcr2gpr x2, c2
    xcr2gpr x3, c3
