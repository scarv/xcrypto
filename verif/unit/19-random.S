
.text

test_start:

	gpr2xcr c1, a1
	gpr2xcr c2, a2
	gpr2xcr c3, a3 
    
    rngseed c1
    rngsamp c2
    rngsamp c3

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    rngsamp c2
    rngseed c1
    rngsamp c3

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
