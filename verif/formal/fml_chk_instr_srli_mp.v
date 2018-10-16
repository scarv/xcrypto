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

`VTX_CHECKER_MODULE_BEGIN(instr_srli_mp)

reg [63:0] value;

//
// srli_mp
//
`VTX_CHECK_INSTR_BEGIN(srli_mp) 

    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    value = {`CRS1 , `CRS2} >> dec_arg_cmshamt;

    `VTX_ASSERT_CRDM_VALUE_IS(value)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(srli_mp)

`VTX_CHECKER_MODULE_END

