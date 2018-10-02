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

`VTX_CHECKER_MODULE_BEGIN(instr_ins_cr)

wire [ 4:0] ins_begin = {dec_arg_cs,1'b0};
wire [ 4:0] ins_end   = {dec_arg_cl,1'b0} + ins_begin;
wire [31:0] ins_mask  = ~(32'hFFFF_FFFF << (ins_end+ins_begin));
wire [31:0] ins_result= 
    ((`CRS1 & ins_mask) << ins_begin) |
    (vtx_crd_val_pre & (ins_mask  << ins_begin));
    

//
// ins_cr
//
`VTX_CHECK_INSTR_BEGIN(ins_cr) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(ins_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(ins_cr)

`VTX_CHECKER_MODULE_END
