
.text

test_start:

    lui.cr  c0, 0x1111
    lli.cr  c0, 0x1111
    lui.cr  c1, 0x2222
    lli.cr  c1, 0x2222
    lui.cr  c2, 0x0000
    lli.cr  c2, 0x0000
    lui.cr  c3, 0x3333
    lli.cr  c3, 0x3333

    gtu.mp  x0 , x0, c0, c3
    gtu.mp  x1 , x1, c1, c0
    gtu.mp  x2 , x9, c2, c1
    gtu.mp  x3 , x0, c3, c2
    gtu.mp  x4 , x4, c0, c1
    gtu.mp  x5 , x3, c1, c2
    gtu.mp  x16, x2, c2, c3
    gtu.mp  x15, x1, c3, c0

    mv2gpr x16, c0
    mv2gpr x16, c1
    mv2gpr x16, c2
    mv2gpr x16, c3
    mv2gpr x16, c4
