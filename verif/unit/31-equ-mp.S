
.text

test_start:

    xc.ld.hi  c0, 0x1111
    xc.ld.li  c0, 0x1111
    xc.ld.hi  c1, 0x2222
    xc.ld.li  c1, 0x2222
    xc.ld.hi  c2, 0x0000
    xc.ld.li  c2, 0x0000
    xc.ld.hi  c3, 0x3333
    xc.ld.li  c3, 0x3333

    xc.mequ  x0 , x0, c0, c3
    xc.mequ  x1 , x1, c1, c1
    xc.mequ  x2 , x9, c2, c1
    xc.mequ  x3 , x0, c3, c2
    xc.mequ  x4 , x4, c0, c0
    xc.mequ  x5 , x3, c1, c2
    xc.mequ  x16, x2, c2, c3
    xc.mequ  x15, x1, c3, c3

    xc.xcr2gpr x16, c0
    xc.xcr2gpr x16, c1
    xc.xcr2gpr x16, c2
    xc.xcr2gpr x16, c3
    xc.xcr2gpr x16, c4
