
.text

test_start:

    lui.cr  c0, 0xF4F3
    lli.cr  c0, 0xF2F1
    lui.cr  c1, 0x1111
    lli.cr  c1, 0x1111
    lui.cr  c9, 0xFFFF
    lli.cr  c9, 0xFFFF
    
    mv2gpr  x1, c0
    mv2gpr  x1, c1

    slli.mp  (c2,c3), c0, c1, 1
    mv2gpr  x1, c2
    mv2gpr  x1, c3

    slli.mp  (c4,c5), c1, c0, 2
    mv2gpr  x1, c4
    mv2gpr  x1, c5

    slli.mp  (c6,c7), c9, c1, 4
    mv2gpr  x1, c6
    mv2gpr  x1, c7

    slli.mp  (c8,c9), c0, c9, 8
    mv2gpr  x1, c8
    mv2gpr  x1, c9

    slli.mp  (c2,c3), c0, c1, 3
    slli.mp  (c4,c5), c1, c0, 5
    slli.mp  (c6,c7), c9, c1, 12
    slli.mp  (c8,c9), c0, c9, 15

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

