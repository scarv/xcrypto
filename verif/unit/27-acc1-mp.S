
.text

test_start:

    ld.hi  c0, 0x1111
    ld.li  c0, 0x1111

    ld.hi  c1, 0x2222
    ld.li  c1, 0x2222
    
    ld.hi  c2, 0x3333
    ld.li  c2, 0x3333
    
    ld.hi  c3, 0x4444
    ld.li  c3, 0x4444

    ld.hi  c9, 0xFFFF
    ld.li  c9, 0xFFFF
    
    xcr2gpr  x1, c0
    xcr2gpr  x1, c1

    macc.1  (c2,c3), c0
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3

    macc.1  (c4,c5), c1
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5

    macc.1  (c6,c7), c9
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7

    macc.1  (c8,c9), c0
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9

    macc.1  (c2,c3), c0
    macc.1  (c4,c5), c1
    macc.1  (c6,c7), c9
    macc.1  (c8,c9), c0

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9

