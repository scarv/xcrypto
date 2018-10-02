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

`VTX_CHECKER_MODULE_BEGIN(instr_ext_cr)

wire [ 4:0] ext_begin = {dec_arg_cs,1'b0};
wire [ 4:0] ext_end   = {dec_arg_cl,1'b0} + ext_begin;
wire [31:0] ext_mask  = 32'hFFFF_FFFF >> (ext_end-ext_begin);
wire [31:0] ext_result= (`CRS1 >> ext_begin) & ext_mask;

//
// ext_cr
//
`VTX_CHECK_INSTR_BEGIN(ext_cr) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(ext_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(ext_cr)

`VTX_CHECKER_MODULE_END
