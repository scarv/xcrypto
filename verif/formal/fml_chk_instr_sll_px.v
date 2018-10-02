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

`VTX_CHECKER_MODULE_BEGIN(instr_sll_px)

// Pack width of the instruction
wire [2:0] pw = `VTX_INSTR_PACK_WIDTH;

// Compute expected result into register called "result". See
// `verif/formal/fml_pack_widths.vh` for macro definition.
`PACK_WIDTH_SHIFT_OPERATION_RESULT(<<,`CRS2[4:0])

//
// sll_px
//
`VTX_CHECK_INSTR_BEGIN(sll_px) 

    // Correct pack width encoding value or instruction gives in bad
    // opcode result.
    `VTX_ASSERT_PACK_WIDTH_CORRECT

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
        `VTX_ASSERT_CRD_VALUE_IS(result)
    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(sll_px)

`VTX_CHECKER_MODULE_END
