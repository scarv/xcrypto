
.text

test_start:

	mv2cop c1, a1
	mv2cop c2, a2
	mv2cop c3, a3 

    sw.cr  c1, 0(a1)
    sw.cr  c2, 4(a1)
    sw.cr  c3,16(a1)

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3

    sw.cr  c1, 0(a1)
    sw.cr  c2, 4(a1)
    sw.cr  c3,16(a1)

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3
    
    sw.cr  c1, 0(a1)
    sw.cr  c2, 4(a1)
    sw.cr  c3,16(a1)

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3
    
    sw.cr  c1, 0(a1)
    sw.cr  c2, 4(a1)
    sw.cr  c3,16(a1)

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3
    
    sw.cr  c1, 0(a1)
    sw.cr  c2, 4(a1)
    sw.cr  c3,16(a1)

    mv2gpr a1, c1
    mv2gpr a2, c2
    mv2gpr a3, c3
