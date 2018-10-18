
.text

test_start:

    ld.hi  c0, 0x7654
    ld.li  c0, 0x3210
    ld.hi  c1, 0x0000
    ld.li  c1, 2

    psrl.i  w, c2, c0, 5
    psrl.i  h, c3, c0, 4
    psrl.i  b, c4, c0, 3
    psrl.i  n, c5, c0, 2
    psrl.i  c, c6, c0, 1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    psll.i  w, c2, c0, 5
    psll.i  h, c3, c0, 4
    psll.i  b, c4, c0, 3
    psll.i  n, c5, c0, 2
    psll.i  c, c6, c0, 1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
    
    prot.i  w, c2, c0, 5
    prot.i  h, c3, c0, 4
    prot.i  b, c4, c0, 3
    prot.i  n, c5, c0, 2
    prot.i  c, c6, c0, 1

    xcr2gpr  x1, c0
    xcr2gpr  x1, c1
    xcr2gpr  x1, c2
    xcr2gpr  x1, c3
    xcr2gpr  x1, c4
    xcr2gpr  x1, c5
    xcr2gpr  x1, c6
