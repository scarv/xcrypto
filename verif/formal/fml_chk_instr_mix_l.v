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

`VTX_CHECKER_MODULE_BEGIN(instr_mix_l)

wire [31:0] rotated = ({`CRS1,`CRS1} >> dec_arg_lut4);

wire [31:0] lmix_result = 
    (( `CRS2) & rotated        ) |
    ((~`CRS2) & vtx_crd_val_pre) ;

//
// mix_l
//
`VTX_CHECK_INSTR_BEGIN(mix_l) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(lmix_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(mix_l)

`VTX_CHECKER_MODULE_END
