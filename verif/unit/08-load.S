
.text

test_start:

	mv2cop c1, a1
	mv2cop c2, a2
	mv2cop c3, a3 

    lw.cr  c1, 0(a1)
    lw.cr  c2, 4(a1)
    lw.cr  c3,16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3

    lw.cr  c1, 0(a1)
    lw.cr  c2, 4(a1)
    lw.cr  c3,16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    lw.cr  c1, 0(a1)
    lw.cr  c2, 4(a1)
    lw.cr  c3,16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    lw.cr  c1, 0(a1)
    lw.cr  c2, 4(a1)
    lw.cr  c3,16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    lw.cr  c1, 0(a1)
    lw.cr  c2, 4(a1)
    lw.cr  c3,16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
