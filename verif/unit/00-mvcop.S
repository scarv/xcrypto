
.text

test_start:
	
	xc.gpr2xcr c1, a1
	xc.gpr2xcr c3, t2
	xc.gpr2xcr c6, a3 
	xc.gpr2xcr c5, t4
	xc.gpr2xcr c9, a5

	xc.xcr2gpr a1, c1
	xc.xcr2gpr t2, c3
	xc.xcr2gpr a3, c6 
	xc.xcr2gpr t4, c5
	xc.xcr2gpr a5, c9
