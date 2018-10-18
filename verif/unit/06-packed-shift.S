
.text

test_start:

    ld.hi  c0, 0xFFFF
    ld.li  c0, 0xFFFF
    ld.hi  c1, 0x0000
    ld.li  c1, 1

    psrl  w, c2, c0, c1
    psrl  h, c3, c0, c1
    psrl  b, c4, c0, c1
    psrl  n, c5, c0, c1
    psrl  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    psll  w, c2, c0, c1
    psll  h, c3, c0, c1
    psll  b, c4, c0, c1
    psll  n, c5, c0, c1
    psll  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    prot  w, c2, c0, c1
    prot  h, c3, c0, c1
    prot  b, c4, c0, c1
    prot  n, c5, c0, c1
    prot  c, c6, c0, c1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
