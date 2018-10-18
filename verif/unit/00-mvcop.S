
.text

test_start:
	
	gpr2xcr c1, a1
	gpr2xcr c3, t2
	gpr2xcr c6, a3 
	gpr2xcr c5, t4
	gpr2xcr c9, a5
	
	xcr2gpr a1, c1
	xcr2gpr t2, c3
	xcr2gpr a3, c6 
	xcr2gpr t4, c5
	xcr2gpr a5, c9
