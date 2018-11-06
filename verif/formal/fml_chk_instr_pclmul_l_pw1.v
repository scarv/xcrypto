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
// Checker for bit packed multiply instruction.
// - Checks pack width 1 - i.e. a single 32x32 carryless multiply.
//
`VTX_CHECKER_MODULE_BEGIN(instr_pclmul_l_pw1)

// Pack width of the instruction
wire [2:0] pw = `VTX_INSTR_PACK_WIDTH;

// What we expect the result to be for a pclmul_l instruction.
reg [31:0] expected_result;

// Only check pclmul_l instructions
always @(posedge `VTX_CLK_NAME) if(vtx_valid) restrict(dec_pclmul_l);

//
// Include this file which contains a process computing "expected_result"
// Included so it can be shared across all "fml_chl_instr_pclmul_*" files.
`include "fml_pclmul_l_result.vh"

//
// pclmul_l
//
`VTX_CHECK_INSTR_BEGIN(pclmul_l) 

    `VTX_ASSUME(pw != SCARV_COP_PW_2  &&
                pw != SCARV_COP_PW_4  &&
                pw != SCARV_COP_PW_8  &&
                pw != SCARV_COP_PW_16 );

    // Correct pack width encoding value or instruction gives in bad
    // opcode result.
    `VTX_ASSERT_PACK_WIDTH_CORRECT

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
        `VTX_ASSERT_CRD_VALUE_IS(expected_result)

        // Other Pack widths checked by dedicated proofs
        `VTX_COVER(pw == SCARV_COP_PW_1 );
    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(pclmul_l)

`VTX_CHECKER_MODULE_END

