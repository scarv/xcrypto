
.text

test_start:

	gpr2xcr c1, a1
	gpr2xcr c2, a2
	gpr2xcr c3, a3 

    st.h c1,(0), 0(a1)
    st.h c2,(0), 4(a1)
    st.h c3,(0),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3

    st.h c1,(1), 0(a1)
    st.h c2,(1), 4(a1)
    st.h c3,(1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    st.h c1,(0),10(a1)
    st.h c2,(0),14(a1)
    st.h c3,(0),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    st.h c1,(1), 0(a1)
    st.h c2,(1), 4(a1)
    st.h c3,(1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
    
    st.h c1,(1), 0(a1)
    st.h c2,(1), 4(a1)
    st.h c3,(1),16(a1)

    xcr2gpr a1, c1
    xcr2gpr a2, c2
    xcr2gpr a3, c3
