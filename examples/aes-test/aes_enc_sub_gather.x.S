.section .text
.global aes_enc_sub_gather
aes_enc_sub_gather:
    # a0 =  uint32_t * s 
	# a1 =  uint8_t * sbox 

	lw t0, 0(a0)
	lw t1, 4(a0)
	lw t2, 8(a0)
	lw t3, 12(a0)
	
	xc.gpr2xcr  c0, t0
	xc.gpr2xcr  c1, t1
	xc.gpr2xcr  c2, t2
	xc.gpr2xcr  c3, t3	

	xc.gather.b c4, c0, a1
	xc.gather.b c5, c1, a1
	xc.gather.b c6, c2, a1
	xc.gather.b c7, c3, a1

	xc.st.w c4, 0(a0)
	xc.st.w c5, 4(a0)
	xc.st.w c6, 8(a0)
	xc.st.w c7, 12(a0)

	ret
