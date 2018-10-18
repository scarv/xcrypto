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

`VTX_CHECKER_MODULE_BEGIN(instr_pperm_h1)

wire [3:0] split[3:0];

assign split[3] = `CRS1[31:28];
assign split[2] = `CRS1[27:24];
assign split[1] = `CRS1[23:20];
assign split[0] = `CRS1[19:16];

wire [31:0] pperm_h1_result = {
    split[dec_arg_b3], split[dec_arg_b2], split[dec_arg_b1], split[dec_arg_b0],
    `CRS1[15: 0]
};

//
// pperm_h1
//
`VTX_CHECK_INSTR_BEGIN(pperm_h1) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(pperm_h1_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(pperm_h1)

`VTX_CHECKER_MODULE_END
