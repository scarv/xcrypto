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

`include "fml_pack_widths.vh"

`VTX_CHECKER_MODULE_BEGIN(instr_mmul_3)

reg [63:0] value;

// Assume only this instruction is ever run.
always @(posedge `VTX_CLK_NAME) if(vtx_valid) assume(dec_mmul_3);

//
// mmul_3
//
`VTX_CHECK_INSTR_BEGIN(mmul_3) 

    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    value = (`CRS1 * `CRS2) + `CRS3;

    `VTX_ASSERT(vtx_crd1_val_post == value[31:0]);

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(mmul_3)

`VTX_CHECKER_MODULE_END

