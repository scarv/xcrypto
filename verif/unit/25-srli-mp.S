
.text

test_start:

    ld.hi  c0, 0xF4F3
    ld.li  c0, 0xF2F1
    ld.hi  c1, 0x1111
    ld.li  c1, 0x1111
    ld.hi  c9, 0xFFFF
    ld.li  c9, 0xFFFF
    
    xcr2gpr  x1, c0
    xcr2gpr  x1, c1

    msrl.i  (c2,c3), c0, c1, 1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3

    msrl.i  (c4,c5), c1, c0, 2
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5

    msrl.i  (c6,c7), c9, c1, 4
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7

    msrl.i  (c8,c9), c0, c9, 8
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9

    msrl.i  (c2,c3), c0, c1, 3
    msrl.i  (c4,c5), c1, c0, 5
    msrl.i  (c6,c7), c9, c1, 12
    msrl.i  (c8,c9), c0, c9, 15

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

