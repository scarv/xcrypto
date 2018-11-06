
.text

test_start:

	xc.gpr2xcr c1, a1
	xc.gpr2xcr c2, a2
	xc.gpr2xcr c3, a3 

    xc.rngseed c1
    xc.rngsamp c2
    xc.rngsamp c3

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.rngsamp c2
    xc.rngseed c1
    xc.rngsamp c3

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3
    
    xc.rngtest x2
    xc.rngtest x1
    xc.rngtest x3

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3
