
.text

test_start:

    ld.hi  c0, 0xF4F3
    ld.li  c0, 0xF2F1
    ld.hi  c1, 0x1111
    ld.li  c1, 0x1111
    ld.hi  c9, 0xFFFF
    ld.li  c9, 0xFFFF

    ld.hi  c15, 0
    ld.li  c15, 1
    
    xcr2gpr  x1, c0
    xcr2gpr  x1, c1

    sll.mp  (c2,c3), c0, c1, c15
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3

    ld.li  c15, 2
    sll.mp  (c4,c5), c1, c0, c15
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5

    ld.li  c15, 4
    sll.mp  (c6,c7), c9, c1, c15
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7

    ld.li  c15, 8
    sll.mp  (c8,c9), c0, c9, c15
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9

    ld.li  c15, 2
    sll.mp  (c2,c3), c0, c1, c15
    ld.li  c15, 3
    sll.mp  (c4,c5), c1, c0, c15
    ld.li  c15, 7
    sll.mp  (c6,c7), c9, c1, c15
    ld.li  c15, 15
    sll.mp  (c8,c9), c0, c9, c15

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

