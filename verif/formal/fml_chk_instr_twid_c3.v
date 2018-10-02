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

`VTX_CHECKER_MODULE_BEGIN(instr_twid_c3)

wire [7:0] split[3:0];

assign split[3] = `CRS1[31:30];
assign split[2] = `CRS1[29:28];
assign split[1] = `CRS1[27:26];
assign split[0] = `CRS1[25:24];

wire [31:0] twid_c3_result = {
    split[dec_arg_b3], split[dec_arg_b2], split[dec_arg_b1], split[dec_arg_b0],
    `CRS1[23: 0],
};

//
// twid_c3
//
`VTX_CHECK_INSTR_BEGIN(twid_c3) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(twid_c3_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(twid_c3)

`VTX_CHECKER_MODULE_END
