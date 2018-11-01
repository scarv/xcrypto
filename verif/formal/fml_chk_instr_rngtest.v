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


`VTX_CHECKER_MODULE_BEGIN(instr_rngtest)

//
// rngtest
//
//  Checks that the RNG reports its entropy health correctly.
//
`VTX_CHECK_INSTR_BEGIN(rngtest) 
    
    // Always succeeds
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    // Returns either 32'b1 or 32'b0
    `VTX_ASSERT(vtx_instr_wdata == 32'b0 ||
                vtx_instr_wdata == 32'b1);
    
    // Returns either 32'b1 or 32'b0
    `VTX_ASSERT_WADDR_IS(dec_arg_crd)

    // Never writes to GPRS
    `VTX_ASSERT_WEN_IS_SET
    
`VTX_CHECK_INSTR_END(rngtest)

`VTX_CHECKER_MODULE_END
