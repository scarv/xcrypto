
.text

test_start:

    lui.cr c0, 0xF4E3
    lli.cr c0, 0xD2C1

    twid.b  c1, c0, 3,2,1,0
    twid.b  c2, c0, 0,1,2,3
    twid.b  c3, c0, 2,0,3,1
    twid.b  c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    twid.n0 c1, c0, 3,2,1,0
    twid.n0 c2, c0, 0,1,2,3
    twid.n0 c3, c0, 2,0,3,1
    twid.n0 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    twid.n1 c1, c0, 3,2,1,0
    twid.n1 c2, c0, 0,1,2,3
    twid.n1 c3, c0, 2,0,3,1
    twid.n1 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    twid.c0 c1, c0, 3,2,1,0
    twid.c0 c2, c0, 0,1,2,3
    twid.c0 c3, c0, 2,0,3,1
    twid.c0 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    twid.c1 c1, c0, 3,2,1,0
    twid.c1 c2, c0, 0,1,2,3
    twid.c1 c3, c0, 2,0,3,1
    twid.c1 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    twid.c2 c1, c0, 3,2,1,0
    twid.c2 c2, c0, 0,1,2,3
    twid.c2 c3, c0, 2,0,3,1
    twid.c2 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
    
    twid.c3 c1, c0, 3,2,1,0
    twid.c3 c2, c0, 0,1,2,3
    twid.c3 c3, c0, 2,0,3,1
    twid.c3 c4, c0, 0,0,0,0

    xcr2gpr  a1, c1
    xcr2gpr  a1, c2
    xcr2gpr  a1, c3
    xcr2gpr  a1, c4
