
.text

test_start:

    lui.cr  c0, 0x1111
    lli.cr  c0, 0x1111

    lui.cr  c1, 0x2222
    lli.cr  c1, 0x2222
    
    lui.cr  c2, 0x3333
    lli.cr  c2, 0x3333
    
    lui.cr  c3, 0x4444
    lli.cr  c3, 0x4444

    lui.cr  c9, 0xFFFF
    lli.cr  c9, 0xFFFF
    
    mv2gpr  x1, c0
    mv2gpr  x1, c1

    acc1.mp  (c2,c3), c0
    mv2gpr  x1, c2
    mv2gpr  x1, c3

    acc1.mp  (c4,c5), c1
    mv2gpr  x1, c4
    mv2gpr  x1, c5

    acc1.mp  (c6,c7), c9
    mv2gpr  x1, c6
    mv2gpr  x1, c7

    acc1.mp  (c8,c9), c0
    mv2gpr  x1, c8
    mv2gpr  x1, c9

    acc1.mp  (c2,c3), c0
    acc1.mp  (c4,c5), c1
    acc1.mp  (c6,c7), c9
    acc1.mp  (c8,c9), c0

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

