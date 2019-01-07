
.text

test_start:

    xc.gpr2xcr c0, x0
    xc.gpr2xcr c1, x1
    xc.gpr2xcr c2, x2
    xc.gpr2xcr c3, x3

    xc.bop c4, c5, c6, 0b00000000
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b00010001
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b00100010
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b00110011
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b01000100
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b01010101
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b01100110
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b01110111
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b10001000
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b10011001
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b10101010
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b10111011
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b11001100
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b11011101
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b11101110
    xc.xcr2gpr x4, c4        
    xc.xcr2gpr x1, c1        
    xc.xcr2gpr x2, c2        
    xc.xcr2gpr x3, c3        
                             
    xc.bop c4, c5, c6, 0b11111111
    xc.xcr2gpr x4, c4
    xc.xcr2gpr x1, c1
    xc.xcr2gpr x2, c2
    xc.xcr2gpr x3, c3
