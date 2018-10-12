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

`VTX_CHECKER_MODULE_BEGIN(instr_bop_cr)

wire [31:0] bop_result;

genvar i;
generate for(i=0; i < 32; i = i + 1) begin
    assign bop_result[i] = dec_arg_lut4[{`CRS1[i],`CRS2[i]}];
end endgenerate

//
// bop_cr
//
`VTX_CHECK_INSTR_BEGIN(bop_cr) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(bop_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(bop_cr)

`VTX_CHECKER_MODULE_END
