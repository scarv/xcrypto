
.text

test_start:

    lui.cr  c0, 0xF4F3
    lli.cr  c0, 0xF2F1
    lui.cr  c1, 0x1111
    lli.cr  c1, 0x1111
    lui.cr  c3, 0x4444
    lli.cr  c3, 0x4444
    lui.cr  c9, 0xFFFF
    lli.cr  c9, 0xFFFF

    mac.mp  (c2,c3), c0, c1, c3
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3

    mac.mp  (c4,c5), c1, c0, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5

    mac.mp  (c6,c7), c9, c1, c3
    xcr2gpr  x1, c6
    xcr2gpr  x1, c7

    mac.mp  (c8,c9), c0, c9, c3
    xcr2gpr  x1, c8
    xcr2gpr  x1, c9

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1

    mac.mp  (c2,c3), c4, c1, c3
    mac.mp  (c4,c5), c3, c2, c3
    mac.mp  (c6,c7), c2, c3, c3
    mac.mp  (c8,c9), c1, c4, c3

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

