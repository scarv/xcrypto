
.text

test_start:

	gpr2xcr c1, a1
	gpr2xcr c2, a2
	gpr2xcr c3, a3 
    
    scatter.b c2, c1, a1
    scatter.b c2, c1, a1
    scatter.b c2, c1, a1

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3

    scatter.b c3, c1, a1
    scatter.b c2, c2, a1
    scatter.b c1, c1, a1

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
