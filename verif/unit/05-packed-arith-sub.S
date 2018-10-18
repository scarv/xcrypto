
.text

test_start:

    ld.hi  c0, 0xF4F3
    ld.li  c0, 0xF2F1
    ld.hi  c1, 0x1111
    ld.li  c1, 0x1111

    psub  w, c2, c0, c1
    psub  h, c3, c0, c1
    psub  b, c4, c0, c1
    psub  n, c5, c0, c1
    psub  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    psub  w, c2, c0, c1
    psub  h, c3, c0, c1
    psub  b, c4, c0, c1
    psub  n, c5, c0, c1
    psub  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    psub  w, c2, c0, c1
    psub  h, c3, c0, c1
    psub  b, c4, c0, c1
    psub  n, c5, c0, c1
    psub  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
