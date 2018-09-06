
.text

test_start:
	
	mv2cop c1, a1
	mv2cop c3, t2
	mv2cop c6, a3 
	mv2cop c5, t4
	mv2cop c9, a5
	
	mv2gpr a1, c1
	mv2gpr t2, c3
	mv2gpr a3, c6 
	mv2gpr t4, c5
	mv2gpr a5, c9
