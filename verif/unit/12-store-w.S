
.text

test_start:

	xc.gpr2xcr c1, a1
	xc.gpr2xcr c2, a2
	xc.gpr2xcr c3, a3 

    xc.st.w  c1, 0(a1)
    xc.st.w  c2, 4(a1)
    xc.st.w  c3,16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.st.w  c1, 0(a1)
    xc.st.w  c2, 4(a1)
    xc.st.w  c3,16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.st.w  c1, 0(a1)
    xc.st.w  c2, 4(a1)
    xc.st.w  c3,16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.st.w  c1, 0(a1)
    xc.st.w  c2, 4(a1)
    xc.st.w  c3,16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3

    xc.st.w  c1, 0(a1)
    xc.st.w  c2, 4(a1)
    xc.st.w  c3,16(a1)

    xc.xcr2gpr a1, c1
    xc.xcr2gpr a2, c2
    xc.xcr2gpr a3, c3
