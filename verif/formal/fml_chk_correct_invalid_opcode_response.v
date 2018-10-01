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


`VTX_CHECKER_MODULE_BEGIN(correct_invalid_opcode_response)

//
// Check that we always correctly get a BAD_INS result on an invalid opcode.
//
`VTX_CHECK_BEGIN(correct_invalid_opcode_response)
    if(dec_invalid_opcode) begin
        assert(vtx_instr_result == SCARV_COP_INSN_BAD_INS);
    end else begin
        assert(vtx_instr_result != SCARV_COP_INSN_BAD_INS);
    end
`VTX_CHECK_END(correct_invalid_opcode_response)

`VTX_CHECKER_MODULE_END
