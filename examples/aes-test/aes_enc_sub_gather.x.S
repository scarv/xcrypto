.section .text
.global aes_enc_sub_gather
aes_enc_sub_gather:
    # a0 =  uint32_t * s 
	# a1 =  uint8_t * sbox 

	xc.ld.w c0,  0(a0)
	xc.ld.w c1,  4(a0)
	xc.ld.w c2,  8(a0)
	xc.ld.w c3, 12(a0)

	xc.gather.b c4, c0, a1
	xc.gather.b c5, c1, a1
	xc.gather.b c6, c2, a1
	xc.gather.b c7, c3, a1

	xc.st.w c4, 0(a0)
	xc.st.w c5, 4(a0)
	xc.st.w c6, 8(a0)
	xc.st.w c7, 12(a0)

	ret
