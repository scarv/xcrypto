
.text

test_start:

    lui.cr  c0, 0xF4F3
    lli.cr  c0, 0xF2F1
    lui.cr  c1, 0x1111
    lli.cr  c1, 0x1111

    add.px  w, c2, c0, c1
    add.px  h, c3, c0, c1
    add.px  b, c4, c0, c1
    add.px  n, c5, c0, c1
    add.px  c, c6, c0, c1

    mv2gpr  x1, c0
    mv2gpr  x1, c1
    mv2gpr  x1, c2
    mv2gpr  x1, c3
    mv2gpr  x1, c4
    mv2gpr  x1, c5
    mv2gpr  x1, c6
    
    sub.px  w, c2, c0, c1
    sub.px  h, c3, c0, c1
    sub.px  b, c4, c0, c1
    sub.px  n, c5, c0, c1
    sub.px  c, c6, c0, c1

    mv2gpr  x1, c0
    mv2gpr  x1, c1
    mv2gpr  x1, c2
    mv2gpr  x1, c3
    mv2gpr  x1, c4
    mv2gpr  x1, c5
    mv2gpr  x1, c6
    
    mul.px  w, c2, c0, c1
    mul.px  h, c3, c0, c1
    mul.px  b, c4, c0, c1
    mul.px  n, c5, c0, c1
    mul.px  c, c6, c0, c1

    mv2gpr  x1, c0
    mv2gpr  x1, c1
    mv2gpr  x1, c2
    mv2gpr  x1, c3
    mv2gpr  x1, c4
    mv2gpr  x1, c5
    mv2gpr  x1, c6
