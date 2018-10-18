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

`VTX_CHECKER_MODULE_BEGIN(instr_sll_mp)

reg [63:0] value;

//
// sll_mp
//
`VTX_CHECK_INSTR_BEGIN(sll_mp) 

    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    value = {`CRS1 , `CRS2} << `CRS3;

    if(`CRS3 >= 64) begin
        
        // Give zero if shift amount greater than doubleword width.
        `VTX_ASSERT_CRDM_VALUE_IS(64'b0)

    end else begin

        `VTX_ASSERT_CRDM_VALUE_IS(value)

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(sll_mp)

`VTX_CHECKER_MODULE_END

