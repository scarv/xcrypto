
.text

test_start:

    xc.ld.hiu  c0, 0x7654
    xc.ld.liu  c0, 0x3210
    xc.ld.hiu  c1, 0x0000
    xc.ld.liu  c1, 2

    xc.psrl.i  w, c2, c0, 5
    xc.psrl.i  h, c3, c0, 4
    xc.psrl.i  b, c4, c0, 3
    xc.psrl.i  n, c5, c0, 2
    xc.psrl.i  c, c6, c0, 1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.psll.i  w, c2, c0, 5
    xc.psll.i  h, c3, c0, 4
    xc.psll.i  b, c4, c0, 3
    xc.psll.i  n, c5, c0, 2
    xc.psll.i  c, c6, c0, 1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.prot.i  w, c2, c0, 5
    xc.prot.i  h, c3, c0, 4
    xc.prot.i  b, c4, c0, 3
    xc.prot.i  n, c5, c0, 2
    xc.prot.i  c, c6, c0, 1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6
