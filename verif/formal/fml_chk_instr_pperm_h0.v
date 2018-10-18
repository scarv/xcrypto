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

`VTX_CHECKER_MODULE_BEGIN(instr_pperm_h0)

wire [3:0] split[3:0];

assign split[3] = `CRS1[15:12];
assign split[2] = `CRS1[11: 8];
assign split[1] = `CRS1[ 7: 4];
assign split[0] = `CRS1[ 3: 0];

wire [31:0] pperm_h0_result = {
    `CRS1[31:16],
    split[dec_arg_b3], split[dec_arg_b2], split[dec_arg_b1], split[dec_arg_b0]
};

//
// pperm_h0
//
`VTX_CHECK_INSTR_BEGIN(pperm_h0) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(pperm_h0_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(pperm_h0)

`VTX_CHECKER_MODULE_END
