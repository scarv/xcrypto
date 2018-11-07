//
// SCARV Project
// 
// University of Bristol
// 
// RISC-V Cryptographic Instruction Set Extension
// 
// Reference Implementation
// 
// 


//
// Check that GPR values only change when they are supposed too.
// - Only the destination registers can change.
// - Destination registers can only change when the instruction
//   succeeds, or errors out part way in the case of gather.*
//
`VTX_CHECKER_MODULE_BEGIN(register_writes_crd)

// Do we expect the crd registers to change?
wire expect_crd_change = 
    dec_gpr2xcr   ||  dec_bop       ||
    dec_padd      ||  dec_ld_bu     ||
    dec_psub      ||  dec_ld_hu     ||
    dec_pmul_l    ||  dec_ld_w      ||
    dec_psll      ||  dec_ld_hi     ||
    dec_psrl      ||  dec_ld_li     ||
    dec_prot      ||  dec_pperm_w   ||
    dec_psll_i    ||  dec_pperm_h0  ||
    dec_psrl_i    ||  dec_pperm_h1  ||
    dec_prot_i    ||  dec_pperm_b0  ||
    dec_rngsamp   ||  dec_pperm_b1  ||
    dec_cmov_t    ||  dec_pperm_b2  ||
    dec_cmov_f    ||  dec_pperm_b3  ||
    dec_gather_b  ||  dec_ins       ||
    dec_gather_h  ||  dec_ext       ||
    dec_mix_l     ||  dec_mix_h      ;

// When set, no CPR should change in value.
wire expect_no_register_writes = 
    dec_xcr2gpr   ||
    dec_rngseed   ||
    dec_scatter_b ||
    dec_scatter_h ||
    dec_mequ      ||
    dec_mlte      ||
    dec_mgte      ||
    dec_st_b      ||
    dec_st_h      ||
    dec_st_w       ; 

genvar i;
generate for(i = 0; i < 16; i = i + 1) begin

    //
    // For each CPR register:
    //  If a CRD change is expected but said register is *not* crd, then
    //  that register should not change.
    //
    `VTX_CHECK_BEGIN(register_writes_non_crd)

        if((dec_arg_crd != i && expect_crd_change) ||
           expect_no_register_writes)                   begin

            `VTX_ASSERT(vtx_cprs_pre[i] == vtx_cprs_post[i]);

        end

    `VTX_CHECK_END(register_writes_non_crd)

end endgenerate

`VTX_CHECKER_MODULE_END
