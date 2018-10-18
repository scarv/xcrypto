
.text

test_start:

    lui.cr  c0, 0x7654
    lli.cr  c0, 0x3210
    lui.cr  c1, 0x0000
    lli.cr  c1, 2

    srli.px  w, c2, c0, 5
    srli.px  h, c3, c0, 4
    srli.px  b, c4, c0, 3
    srli.px  n, c5, c0, 2
    srli.px  c, c6, c0, 1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    slli.px  w, c2, c0, 5
    slli.px  h, c3, c0, 4
    slli.px  b, c4, c0, 3
    slli.px  n, c5, c0, 2
    slli.px  c, c6, c0, 1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    roti.px  w, c2, c0, 5
    roti.px  h, c3, c0, 4
    roti.px  b, c4, c0, 3
    roti.px  n, c5, c0, 2
    roti.px  c, c6, c0, 1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
