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
`VTX_CHECKER_MODULE_BEGIN(register_writes_crdm)

// Do we expect changes to the two multi-precision destination registers?
wire expect_crdm_change = 
    dec_madd_3    ||
    dec_madd_2    ||
    dec_msub_3    ||
    dec_msub_2    ||
    dec_msll_i    ||
    dec_msll      ||
    dec_msrl_i    ||
    dec_msrl      ||
    dec_macc_2    ||
    dec_macc_1    ||
    dec_mmul_1    ; 

genvar i;
generate for(i = 0; i < 16; i = i + 2) begin

    //
    // For each CPR register:
    //  If a CRDM change is expected but said register is *not* in crdm, then
    //  that register should not change.
    //
    `VTX_CHECK_BEGIN(register_writes_non_crdm)

        if({dec_arg_crdm,1'b0} != i && expect_crdm_change) begin
            `VTX_ASSERT(vtx_cprs_pre[i     ] == vtx_cprs_post[i     ]);
            `VTX_ASSERT(vtx_cprs_pre[i|1'b1] == vtx_cprs_post[i|1'b1]);
        end

    `VTX_CHECK_END(register_writes_non_crdm)

end endgenerate

`VTX_CHECKER_MODULE_END
