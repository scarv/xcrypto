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


`VTX_CHECKER_MODULE_BEGIN(instr_mv2gpr)

//
// mv2gpr
//
`VTX_CHECK_INSTR_BEGIN(mv2gpr) 
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_SET
    `VTX_ASSERT_WDATA_IS(vtx_cprs_pre[dec_arg_crs1])
    `VTX_ASSERT_WADDR_IS(dec_arg_rd                )
`VTX_CHECK_INSTR_END(mv2gpr)

`VTX_CHECKER_MODULE_END
