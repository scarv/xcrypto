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


`VTX_CHECKER_MODULE_BEGIN(instr_ld_hi)

wire [15:0] ld_hi_imm = {dec_arg_imm11,dec_arg_imm5};

//
// ld_hi
//
`VTX_CHECK_INSTR_BEGIN(ld_hi) 
    `VTX_ASSERT_CRD_VALUE_IS({ld_hi_imm,vtx_crd_val_pre[15: 0]})
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_CLEAR
`VTX_CHECK_INSTR_END(ld_hi)

`VTX_CHECKER_MODULE_END
