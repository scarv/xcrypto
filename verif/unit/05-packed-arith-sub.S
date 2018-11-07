
.text

test_start:

    xc.ld.hiu  c0, 0xF4F3
    xc.ld.liu  c0, 0xF2F1
    xc.ld.hiu  c1, 0x1111
    xc.ld.liu  c1, 0x1111

    xc.psub  w, c2, c0, c1
    xc.psub  h, c3, c0, c1
    xc.psub  b, c4, c0, c1
    xc.psub  n, c5, c0, c1
    xc.psub  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.psub  w, c2, c0, c1
    xc.psub  h, c3, c0, c1
    xc.psub  b, c4, c0, c1
    xc.psub  n, c5, c0, c1
    xc.psub  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.psub  w, c2, c0, c1
    xc.psub  h, c3, c0, c1
    xc.psub  b, c4, c0, c1
    xc.psub  n, c5, c0, c1
    xc.psub  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6
