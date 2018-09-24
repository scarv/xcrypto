
.text

test_start:

    lui.cr  c0, 0xF4F3
    lli.cr  c0, 0xF2F1
    lui.cr  c1, 0x1111
    lli.cr  c1, 0x1111
    lui.cr  c9, 0xFFFF
    lli.cr  c9, 0xFFFF

    add3.mp  (c2,c3), c0, c1, c3
    add3.mp  (c4,c5), c1, c0, c3
    add3.mp  (c6,c7), c9, c1, c3
    add3.mp  (c8,c9), c0, c9, c3

    mv2gpr  x1, c0
    mv2gpr  x1, c1
    mv2gpr  x1, c2
    mv2gpr  x1, c3
    mv2gpr  x1, c4
    mv2gpr  x1, c5
    mv2gpr  x1, c6
    mv2gpr  x1, c7
    mv2gpr  x1, c8
    mv2gpr  x1, c9

    add3.mp  (c2,c3), c4, c1, c3
    add3.mp  (c4,c5), c3, c2, c3
    add3.mp  (c6,c7), c2, c3, c3
    add3.mp  (c8,c9), c1, c4, c3

    mv2gpr  x1, c0
    mv2gpr  x1, c1
    mv2gpr  x1, c2
    mv2gpr  x1, c3
    mv2gpr  x1, c4
    mv2gpr  x1, c5
    mv2gpr  x1, c6
    mv2gpr  x1, c7
    mv2gpr  x1, c8
    mv2gpr  x1, c9

