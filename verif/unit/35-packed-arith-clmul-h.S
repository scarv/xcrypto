
.text

test_start:

    xc.ld.hiu  c0, 0x0000
    xc.ld.liu  c0, 0x0001
    xc.ld.hiu  c1, 0x0000
    xc.ld.liu  c1, 4  

    xc.pclmul.h  w, c2, c0, c1
    xc.pclmul.h  h, c3, c0, c1
    xc.pclmul.h  b, c4, c0, c1
    xc.pclmul.h  n, c5, c0, c1
    xc.pclmul.h  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.ld.hiu  c0, 0x0000
    xc.ld.liu  c0, 0x0007
    xc.ld.hiu  c1, 0x0000
    xc.ld.liu  c1, 4  

    xc.pclmul.h  w, c2, c0, c1
    xc.pclmul.h  h, c3, c0, c1
    xc.pclmul.h  b, c4, c0, c1
    xc.pclmul.h  n, c5, c0, c1
    xc.pclmul.h  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6

    xc.ld.hiu  c0, 0xF4F3
    xc.ld.liu  c0, 0xF2F1
    xc.ld.hiu  c1, 0x1111
    xc.ld.liu  c1, 0x1111

    xc.pclmul.h  w, c2, c0, c1
    xc.pclmul.h  h, c3, c0, c1
    xc.pclmul.h  b, c4, c0, c1
    xc.pclmul.h  n, c5, c0, c1
    xc.pclmul.h  c, c6, c0, c1

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

    xc.pclmul.h  w, c2, c0, c1
    xc.pclmul.h  h, c3, c0, c1
    xc.pclmul.h  b, c4, c0, c1
    xc.pclmul.h  n, c5, c0, c1
    xc.pclmul.h  c, c6, c0, c1

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

    xc.pclmul.h  w, c2, c0, c1
    xc.pclmul.h  h, c3, c0, c1
    xc.pclmul.h  b, c4, c0, c1
    xc.pclmul.h  n, c5, c0, c1
    xc.pclmul.h  c, c6, c0, c1

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6
