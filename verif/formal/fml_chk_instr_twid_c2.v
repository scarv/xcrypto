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

`VTX_CHECKER_MODULE_BEGIN(instr_twid_c2)

wire [7:0] split[3:0];

assign split[3] = `CRS1[23:22];
assign split[2] = `CRS1[21:20];
assign split[1] = `CRS1[18:18];
assign split[0] = `CRS1[17:16];

wire [31:0] twid_c2_result = {
    `CRS1[31:24],
    split[dec_arg_b3], split[dec_arg_b2], split[dec_arg_b1], split[dec_arg_b0],
    `CRS1[15: 0],
};

//
// twid_c2
//
`VTX_CHECK_INSTR_BEGIN(twid_c2) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(twid_c2_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(twid_c2)

`VTX_CHECKER_MODULE_END
