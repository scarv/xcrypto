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


`VTX_CHECKER_MODULE_BEGIN(instr_lui_cr)

wire [15:0] lui_cr_imm = {dec_arg_imm11,dec_arg_imm5};

//
// lui_cr
//
`VTX_CHECK_INSTR_BEGIN(lui_cr) 
    `VTX_ASSERT_CRD_VALUE_IS({lui_cr_imm,vtx_crd_val_pre[15: 0]})
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_CLEAR
`VTX_CHECK_INSTR_END(lui_cr)

`VTX_CHECKER_MODULE_END
