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

`VTX_CHECKER_MODULE_BEGIN(instr_mmul_1_fixed_regs)

reg [63:0] value;

//
// mmul_1
//
`VTX_CHECK_INSTR_BEGIN(mmul_1) 

    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    assume(dec_arg_crs1 == 1);
    assume(dec_arg_crs2 == 2);
    assume(dec_arg_crs3 == 3);
    assume(dec_arg_crdm == 4);

    value = (`CRS1 * `CRS2) + `CRS3;

    `VTX_ASSERT_CRDM_VALUE_IS(value)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(mmul_1_fixed_regs)

`VTX_CHECKER_MODULE_END


