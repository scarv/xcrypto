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

//
// Checker for 16x16 bit packed multiply instruction.
// - Only checks case where pack width == 2 (i.e. 2.(16x16))
//
`VTX_CHECKER_MODULE_BEGIN(instr_pmul_h_pw2)

// Pack width of the instruction
wire [2:0] pw = `VTX_INSTR_PACK_WIDTH;

// Compute expected result into register called "result". See
// `verif/formal/fml_pack_widths.vh` for macro definition.
`PACK_WIDTH_ARITH_OPERATION_RESULT(*,1)

// Only check pmul_h instructions
always @(posedge `VTX_CLK_NAME) if(vtx_valid) restrict(dec_pmul_h);

//
// pmul_h
//
`VTX_CHECK_INSTR_BEGIN(pmul_h) 

    // Correct pack width encoding value or instruction gives in bad
    // opcode result.
    `VTX_ASSERT_PACK_WIDTH_CORRECT

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin

        restrict(pw == SCARV_COP_PW_2);

        `VTX_ASSERT_CRD_VALUE_IS(result)
        `VTX_COVER(pw == SCARV_COP_PW_2);

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(pmul_h)

`VTX_CHECKER_MODULE_END

