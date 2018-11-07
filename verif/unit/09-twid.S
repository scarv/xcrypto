
.text

test_start:

    xc.ld.hiu c0, 0xF4E3
    xc.ld.liu c0, 0xD2C1

    xc.pperm.w  c1, c0, 3,2,1,0
    xc.pperm.w  c2, c0, 0,1,2,3
    xc.pperm.w  c3, c0, 2,0,3,1
    xc.pperm.w  c4, c0, 0,0,0,0

    xc.xcr2gpr  a1, c1
    xc.xcr2gpr  a1, c2
    xc.xcr2gpr  a1, c3
    xc.xcr2gpr  a1, c4

    xc.pperm.h0 c1, c0, 3,2,1,0
    xc.pperm.h0 c2, c0, 0,1,2,3
    xc.pperm.h0 c3, c0, 2,0,3,1
    xc.pperm.h0 c4, c0, 0,0,0,0

    xc.xcr2gpr  a1, c1
    xc.xcr2gpr  a1, c2
    xc.xcr2gpr  a1, c3
    xc.xcr2gpr  a1, c4

    xc.pperm.h1 c1, c0, 3,2,1,0
    xc.pperm.h1 c2, c0, 0,1,2,3
    xc.pperm.h1 c3, c0, 2,0,3,1
    xc.pperm.h1 c4, c0, 0,0,0,0

    xc.xcr2gpr  a1, c1
    xc.xcr2gpr  a1, c2
    xc.xcr2gpr  a1, c3
    xc.xcr2gpr  a1, c4

    xc.pperm.b0 c1, c0, 3,2,1,0
    xc.pperm.b0 c2, c0, 0,1,2,3
    xc.pperm.b0 c3, c0, 2,0,3,1
    xc.pperm.b0 c4, c0, 0,0,0,0

    xc.xcr2gpr  a1, c1
    xc.xcr2gpr  a1, c2
    xc.xcr2gpr  a1, c3
    xc.xcr2gpr  a1, c4

    xc.pperm.b1 c1, c0, 3,2,1,0
    xc.pperm.b1 c2, c0, 0,1,2,3
    xc.pperm.b1 c3, c0, 2,0,3,1
    xc.pperm.b1 c4, c0, 0,0,0,0

    xc.xcr2gpr  a1, c1
    xc.xcr2gpr  a1, c2
    xc.xcr2gpr  a1, c3
    xc.xcr2gpr  a1, c4

    xc.pperm.b2 c1, c0, 3,2,1,0
    xc.pperm.b2 c2, c0, 0,1,2,3
    xc.pperm.b2 c3, c0, 2,0,3,1
    xc.pperm.b2 c4, c0, 0,0,0,0

    xc.xcr2gpr  a1, c1
    xc.xcr2gpr  a1, c2
    xc.xcr2gpr  a1, c3
    xc.xcr2gpr  a1, c4

    xc.pperm.b3 c1, c0, 3,2,1,0
    xc.pperm.b3 c2, c0, 0,1,2,3
    xc.pperm.b3 c3, c0, 2,0,3,1
    xc.pperm.b3 c4, c0, 0,0,0,0

    xc.xcr2gpr  a1, c1
    xc.xcr2gpr  a1, c2
    xc.xcr2gpr  a1, c3
    xc.xcr2gpr  a1, c4
