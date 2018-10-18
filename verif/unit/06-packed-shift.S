
.text

test_start:

    lui.cr  c0, 0xFFFF
    lli.cr  c0, 0xFFFF
    lui.cr  c1, 0x0000
    lli.cr  c1, 1

    srl.px  w, c2, c0, c1
    srl.px  h, c3, c0, c1
    srl.px  b, c4, c0, c1
    srl.px  n, c5, c0, c1
    srl.px  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    sll.px  w, c2, c0, c1
    sll.px  h, c3, c0, c1
    sll.px  b, c4, c0, c1
    sll.px  n, c5, c0, c1
    sll.px  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    rot.px  w, c2, c0, c1
    rot.px  h, c3, c0, c1
    rot.px  b, c4, c0, c1
    rot.px  n, c5, c0, c1
    rot.px  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
