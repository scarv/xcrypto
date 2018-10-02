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

`VTX_CHECKER_MODULE_BEGIN(instr_hmix_cr)

wire [31:0] rotated = ({`CRS1,`CRS1} >> (16+dec_arg_lut4));

wire [31:0] hmix_result = 
    (( `CRS2) & rotated        ) |
    ((~`CRS2) & vtx_crd_val_pre) ;

//
// hmix_cr
//
`VTX_CHECK_INSTR_BEGIN(hmix_cr) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(hmix_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(hmix_cr)

`VTX_CHECKER_MODULE_END
