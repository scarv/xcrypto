
.text

test_start:

	gpr2xcr c1, a1
	gpr2xcr c2, a2
	gpr2xcr c3, a3 

    sb.cr c1,(0,0), 0(a1)
    sb.cr c2,(0,1), 4(a1)
    sb.cr c3,(1,0),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3

    sb.cr c1,(1,1), 0(a1)
    sb.cr c2,(1,0), 4(a1)
    sb.cr c3,(1,1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    sb.cr c1,(0,0),10(a1)
    sb.cr c2,(0,1),14(a1)
    sb.cr c3,(0,0),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    sb.cr c1,(1,1), 0(a1)
    sb.cr c2,(1,0), 4(a1)
    sb.cr c3,(1,1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    sb.cr c1,(1,0), 0(a1)
    sb.cr c2,(1,1), 4(a1)
    sb.cr c3,(1,0),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
