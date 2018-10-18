
.text

test_start:

    ld.hi  c0, 0x1111
    ld.li  c0, 0x1111
    ld.hi  c1, 0x2222
    ld.li  c1, 0x2222
    ld.hi  c2, 0x0000
    ld.li  c2, 0x0000
    ld.hi  c3, 0x3333
    ld.li  c3, 0x3333

    equ.mp  x0 , x0, c0, c3
    equ.mp  x1 , x1, c1, c1
    equ.mp  x2 , x9, c2, c1
    equ.mp  x3 , x0, c3, c2
    equ.mp  x4 , x4, c0, c0
    equ.mp  x5 , x3, c1, c2
    equ.mp  x16, x2, c2, c3
    equ.mp  x15, x1, c3, c3

    xcr2gpr x16, c0
    xcr2gpr x16, c1
    xcr2gpr x16, c2
    xcr2gpr x16, c3
    xcr2gpr x16, c4
