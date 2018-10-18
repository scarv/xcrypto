
.text

test_start:

    ld.hi c0, 0xF4E3
    ld.li c0, 0xD2C1

    pperm.w  c1, c0, 3,2,1,0
    pperm.w  c2, c0, 0,1,2,3
    pperm.w  c3, c0, 2,0,3,1
    pperm.w  c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    pperm.h0 c1, c0, 3,2,1,0
    pperm.h0 c2, c0, 0,1,2,3
    pperm.h0 c3, c0, 2,0,3,1
    pperm.h0 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    pperm.h1 c1, c0, 3,2,1,0
    pperm.h1 c2, c0, 0,1,2,3
    pperm.h1 c3, c0, 2,0,3,1
    pperm.h1 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    pperm.b0 c1, c0, 3,2,1,0
    pperm.b0 c2, c0, 0,1,2,3
    pperm.b0 c3, c0, 2,0,3,1
    pperm.b0 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    pperm.b1 c1, c0, 3,2,1,0
    pperm.b1 c2, c0, 0,1,2,3
    pperm.b1 c3, c0, 2,0,3,1
    pperm.b1 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    pperm.b2 c1, c0, 3,2,1,0
    pperm.b2 c2, c0, 0,1,2,3
    pperm.b2 c3, c0, 2,0,3,1
    pperm.b2 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    pperm.b3 c1, c0, 3,2,1,0
    pperm.b3 c2, c0, 0,1,2,3
    pperm.b3 c3, c0, 2,0,3,1
    pperm.b3 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
