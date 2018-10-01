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


`VTX_CHECKER_MODULE_BEGIN(instr_mv2cop)

//
// mv2cop
//
`VTX_CHECK_INSTR_BEGIN(mv2cop) 
    `VTX_ASSERT_CRD_VALUE_IS(vtx_instr_rs1)
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_CLEAR
`VTX_CHECK_INSTR_END(mv2cop)

`VTX_CHECKER_MODULE_END
