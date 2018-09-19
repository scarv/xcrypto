
.text

test_start:

	mv2cop c1, a1
	mv2cop c2, a2
	mv2cop c3, a3 
    
    scatter.h c2, c1, a1
    scatter.h c2, c1, a1
    scatter.h c2, c1, a1

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3

    scatter.h c3, c1, a1
    scatter.h c2, c2, a1
    scatter.h c1, c1, a1

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3
