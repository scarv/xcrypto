
.text

test_start:

    xc.ld.hiu  c0, 0xFFFF
    xc.ld.liu  c0, 0xFFFF
    xc.ld.hiu  c1, 0x0000
    xc.ld.liu  c1, 1

    xc.psrl  w, c2, c0, c1
    xc.psrl  h, c3, c0, c1
    xc.psrl  b, c4, c0, c1
    xc.psrl  n, c5, c0, c1
    xc.psrl  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.psll  w, c2, c0, c1
    xc.psll  h, c3, c0, c1
    xc.psll  b, c4, c0, c1
    xc.psll  n, c5, c0, c1
    xc.psll  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.prot  w, c2, c0, c1
    xc.prot  h, c3, c0, c1
    xc.prot  b, c4, c0, c1
    xc.prot  n, c5, c0, c1
    xc.prot  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6
