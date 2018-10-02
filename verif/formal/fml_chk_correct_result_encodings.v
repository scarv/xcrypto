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


`VTX_CHECKER_MODULE_BEGIN(correct_result_encodings)

//
// Check we only ever get the right result encodings from instructions.
//
`VTX_CHECK_BEGIN(correct_result_encodings)
    assert(
        vtx_instr_result == SCARV_COP_INSN_SUCCESS ||
        vtx_instr_result == SCARV_COP_INSN_ABORT   ||
        vtx_instr_result == SCARV_COP_INSN_BAD_INS ||
        vtx_instr_result == SCARV_COP_INSN_BAD_LAD ||
        vtx_instr_result == SCARV_COP_INSN_BAD_SAD ||
        vtx_instr_result == SCARV_COP_INSN_LD_ERR  ||
        vtx_instr_result == SCARV_COP_INSN_ST_ERR 
    );
`VTX_CHECK_END(correct_result_encodings)

`VTX_CHECKER_MODULE_END
