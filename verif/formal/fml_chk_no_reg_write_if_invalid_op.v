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


//
// Check that XCR values never change on an invalid opcode.
//
`VTX_CHECKER_MODULE_BEGIN(no_reg_write_if_invalid_op)

genvar i;
generate for(i = 0; i < 16; i = i + 1) begin

    //
    // For each CPR register:
    //  If the decoded instruction is invalid, assert no XCR register
    //  changed.
    //
    `VTX_CHECK_BEGIN(no_reg_write_if_op_invalid)

        if(dec_invalid_opcode) begin

            `VTX_ASSERT(vtx_cprs_pre[i] == vtx_cprs_post[i]);

        end

    `VTX_CHECK_END(no_reg_write_if_op_invalid)

end endgenerate

`VTX_CHECKER_MODULE_END
