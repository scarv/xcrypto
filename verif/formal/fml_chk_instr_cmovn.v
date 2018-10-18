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


`VTX_CHECKER_MODULE_BEGIN(instr_cmovn)

//
// cmovn
//
`VTX_CHECK_INSTR_BEGIN(cmovn) 
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_CLEAR
    
    if(vtx_crs2_val_pre != 0) begin
        `VTX_ASSERT_CRD_VALUE_IS(vtx_crs1_val_pre)
    end else begin
        `VTX_ASSERT_CRD_VALUE_IS(vtx_crd_val_pre)
    end

`VTX_CHECK_INSTR_END(cmovn)

`VTX_CHECKER_MODULE_END
