
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

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    add.px  w, c2, c0, c1
    add.px  h, c3, c0, c1
    add.px  b, c4, c0, c1
    add.px  n, c5, c0, c1
    add.px  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    add.px  w, c2, c0, c1
    add.px  h, c3, c0, c1
    add.px  b, c4, c0, c1
    add.px  n, c5, c0, c1
    add.px  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
