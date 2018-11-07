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


`VTX_CHECKER_MODULE_BEGIN(instr_ld_liu)

wire [15:0] ld_li_imm = {dec_arg_imm11,dec_arg_imm5};

//
// ld_li
//
`VTX_CHECK_INSTR_BEGIN(ld_liu) 
    `VTX_ASSERT_CRD_VALUE_IS({vtx_crd_val_pre[31:16],ld_li_imm})
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_CLEAR
`VTX_CHECK_INSTR_END(ld_liu)

`VTX_CHECKER_MODULE_END
