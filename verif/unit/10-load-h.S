
.text

test_start:

	mv2cop c1, a1
	mv2cop c2, a2
	mv2cop c3, a3 

    lhu.cr c1,(0), 0(a1)
    lhu.cr c2,(0), 4(a1)
    lhu.cr c3,(0),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3

    lhu.cr c1,(1), 0(a1)
    lhu.cr c2,(1), 4(a1)
    lhu.cr c3,(1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    lhu.cr c1,(0),10(a1)
    lhu.cr c2,(0),14(a1)
    lhu.cr c3,(0),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    lhu.cr c1,(1), 0(a1)
    lhu.cr c2,(1), 4(a1)
    lhu.cr c3,(1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    lhu.cr c1,(1), 0(a1)
    lhu.cr c2,(1), 4(a1)
    lhu.cr c3,(1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
