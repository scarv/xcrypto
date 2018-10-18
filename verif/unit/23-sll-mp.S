
.text

test_start:

    lui.cr  c0, 0xF4F3
    lli.cr  c0, 0xF2F1
    lui.cr  c1, 0x1111
    lli.cr  c1, 0x1111
    lui.cr  c9, 0xFFFF
    lli.cr  c9, 0xFFFF

    lui.cr  c15, 0
    lli.cr  c15, 1
    
    xcr2gpr  x1, c0
    xcr2gpr  x1, c1

    sll.mp  (c2,c3), c0, c1, c15
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3

    lli.cr  c15, 2
    sll.mp  (c4,c5), c1, c0, c15
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5

    lli.cr  c15, 4
    sll.mp  (c6,c7), c9, c1, c15
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7

    lli.cr  c15, 8
    sll.mp  (c8,c9), c0, c9, c15
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9

    lli.cr  c15, 2
    sll.mp  (c2,c3), c0, c1, c15
    lli.cr  c15, 3
    sll.mp  (c4,c5), c1, c0, c15
    lli.cr  c15, 7
    sll.mp  (c6,c7), c9, c1, c15
    lli.cr  c15, 15
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

