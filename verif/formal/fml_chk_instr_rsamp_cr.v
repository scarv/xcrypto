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


`VTX_CHECKER_MODULE_BEGIN(instr_rsamp_cr)

//
// rsamp_cr
//
//  Checks that the most recent sample of the COP RNG is written to the
//  correct register.
//
`VTX_CHECK_INSTR_BEGIN(rsamp_cr) 
    
    // Value of destination register post instruction should be the same
    // as the most recent 32-bit random sample.
    `VTX_ASSERT_CRD_VALUE_IS(vtx_rand_sample);
    
    // Always succeeds
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    // Never writes to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR
    
`VTX_CHECK_INSTR_END(rsamp_cr)

`VTX_CHECKER_MODULE_END
