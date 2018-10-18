
.text

test_start:

	xc.gpr2xcr c1, a1
	xc.gpr2xcr c2, a2
	xc.gpr2xcr c3, a3 

    xc.ld.bu c1,(0,0), 0(a1)
    xc.ld.bu c2,(0,1), 4(a1)
    xc.ld.bu c3,(1,0),16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.ld.bu c1,(1,1), 0(a1)
    xc.ld.bu c2,(1,0), 4(a1)
    xc.ld.bu c3,(1,1),16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.ld.bu c1,(0,0),10(a1)
    xc.ld.bu c2,(0,1),14(a1)
    xc.ld.bu c3,(0,0),16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.ld.bu c1,(1,1), 0(a1)
    xc.ld.bu c2,(1,0), 4(a1)
    xc.ld.bu c3,(1,1),16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.ld.bu c1,(1,0), 0(a1)
    xc.ld.bu c2,(1,1), 4(a1)
    xc.ld.bu c3,(1,0),16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3
