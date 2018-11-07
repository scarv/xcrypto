
.text

test_start:

    xc.ld.hiu  c0, 0x0100
    xc.ld.liu  c0, 0x1011
    xc.ld.hiu  c1, 0x0000
    xc.ld.liu  c1, 6  

    xc.pmul.l  w, c2, c0, c1
    xc.pmul.l  h, c3, c0, c1
    xc.pmul.l  b, c4, c0, c1
    xc.pmul.l  n, c5, c0, c1
    xc.pmul.l  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.ld.hiu  c0, 0x3210
    xc.ld.liu  c0, 0x3210
    xc.ld.hiu  c1, 0x0003
    xc.ld.liu  c1, 0x0004  

    xc.pmul.l  w, c2, c0, c1
    xc.pmul.l  h, c3, c0, c1
    xc.pmul.l  b, c4, c0, c1
    xc.pmul.l  n, c5, c0, c1
    xc.pmul.l  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.ld.hiu  c0, 0xF2F1
    xc.ld.liu  c0, 0xF2F1
    xc.ld.hiu  c1, 0x1111
    xc.ld.liu  c1, 0x1111

    xc.pmul.l  w, c2, c0, c1
    xc.pmul.l  h, c3, c0, c1
    xc.pmul.l  b, c4, c0, c1
    xc.pmul.l  n, c5, c0, c1
    xc.pmul.l  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.ld.hiu  c0, 0xF4F3
    xc.ld.liu  c0, 0xF2F1
    xc.ld.hiu  c1, 0x2222
    xc.ld.liu  c1, 0x2222

    xc.pmul.l  w, c2, c0, c1
    xc.pmul.l  h, c3, c0, c1
    xc.pmul.l  b, c4, c0, c1
    xc.pmul.l  n, c5, c0, c1
    xc.pmul.l  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.ld.hiu  c0, 0xF4F3
    xc.ld.liu  c0, 0xF2F1
    xc.ld.hiu  c1, 0x3333
    xc.ld.liu  c1, 0x3333

    xc.pmul.l  w, c2, c0, c1
    xc.pmul.l  h, c3, c0, c1
    xc.pmul.l  b, c4, c0, c1
    xc.pmul.l  n, c5, c0, c1
    xc.pmul.l  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6
