
.text

test_start:

	xc.gpr2xcr c1, a1
	xc.gpr2xcr c2, a2
	xc.gpr2xcr c3, a3 

    xc.scatter.h c2, c1, a1
    xc.scatter.h c2, c1, a1
    xc.scatter.h c2, c1, a1

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.scatter.h c3, c1, a1
    xc.scatter.h c2, c2, a1
    xc.scatter.h c1, c1, a1

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3
