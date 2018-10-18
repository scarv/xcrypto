
.text

test_start:

    xc.gpr2xcr c0, x0
    xc.gpr2xcr c1, x1
    xc.gpr2xcr c2, x2
    xc.gpr2xcr c3, x3

    xc.bop c4, c5, c6, 0b0000
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b0001
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b0010
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b0011
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b0100
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b0101
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b0110
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b0111
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1000
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1001
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1010
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1011
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1100
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1101
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1110
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3

    xc.bop c4, c5, c6, 0b1111
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3
