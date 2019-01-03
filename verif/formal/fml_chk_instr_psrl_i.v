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

`VTX_CHECKER_MODULE_BEGIN(instr_psrl_i)

// Pack width of the instruction
wire [2:0] pw = 
    {dec_arg_cb, dec_arg_cc} == 2'b00 ? SCARV_COP_PW_1          :
                                        `VTX_INSTR_PACK_WIDTH   ;

wire [4:0] cshamt =
    pw == SCARV_COP_PW_1 ? {dec_arg_ca, dec_arg_cshamt} :
                           {1'b0      , dec_arg_cshamt} ;

// Compute expected result into register called "result". See
// `verif/formal/fml_pack_widths.vh` for macro definition.
`PACK_WIDTH_SHIFT_OPERATION_RESULT(>>,cshamt)

//
// psrl_i
//
`VTX_CHECK_INSTR_BEGIN(psrl_i) 

    // Correct pack width encoding value or instruction gives in bad
    // opcode result.
    `VTX_ASSERT_PACK_WIDTH_CORRECT

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
        `VTX_ASSERT_CRD_VALUE_IS(result)
    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(psrl_i)

`VTX_CHECKER_MODULE_END
