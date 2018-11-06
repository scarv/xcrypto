
.text

test_start:

    xc.ld.hi  c0, 0xF4F3
    xc.ld.li  c0, 0xF2F1
    xc.ld.hi  c1, 0x1111
    xc.ld.li  c1, 0x1111
    xc.ld.hi  c4, 0x2222
    xc.ld.li  c4, 0x2222
    xc.ld.hi  c3, 0x4444
    xc.ld.li  c3, 0x4444
    xc.ld.hi  c9, 0xFFFF
    xc.ld.li  c9, 0xFFFF

    xc.mclmul.1  (c2,c3), c0, c1, c3
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3

    xc.mclmul.1  (c4,c5), c1, c0, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5

    xc.mclmul.1  (c6,c7), c9, c1, c3
    xc.xcr2gpr  x1, c6
    xc.xcr2gpr  x1, c7

    xc.mclmul.1  (c8,c9), c0, c9, c3
    xc.xcr2gpr  x1, c8
    xc.xcr2gpr  x1, c9

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1

    xc.mclmul.1  (c2,c3), c4, c1, c3
    xc.mclmul.1  (c4,c5), c3, c2, c3
    xc.mclmul.1  (c6,c7), c2, c3, c3
    xc.mclmul.1  (c8,c9), c1, c4, c3
    
    xc.mclmul.1  (c8,c9), c1, c4, c3

    xc.xcr2gpr  x1, c0
    xc.xcr2gpr  x1, c1
    xc.xcr2gpr  x1, c2
    xc.xcr2gpr  x1, c3
    xc.xcr2gpr  x1, c4
    xc.xcr2gpr  x1, c5
    xc.xcr2gpr  x1, c6
    xc.xcr2gpr  x1, c7
    xc.xcr2gpr  x1, c8
    xc.xcr2gpr  x1, c9

