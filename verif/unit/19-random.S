
.text

test_start:

	mv2cop c1, a1
	mv2cop c2, a2
	mv2cop c3, a3 
    
    rseed.cr c1
    rsamp.cr c2
    rsamp.cr c3

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3
    
    rsamp.cr c2
    rseed.cr c1
    rsamp.cr c3

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3
