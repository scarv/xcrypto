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

`include "fml_common.vh"

`VTX_CHECKER_MODULE_BEGIN(instr_lw_cr)

wire [31:0] lw_addr = vtx_instr_rs1 + {{21{dec_arg_imm11[10]}},dec_arg_imm11};

//
// lw_cr
//
`VTX_CHECK_INSTR_BEGIN(lw_cr) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_ST_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_SAD);

    if(lw_addr[1:0]) begin

        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_BAD_LAD)

    end else if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin

        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == lw_addr);
        `VTX_ASSERT_CRD_VALUE_IS(vtx_mem_rdata_0)

    end else if(vtx_instr_result == SCARV_COP_INSN_LD_ERR) begin
        
        // Transaction should have started correctly.
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == lw_addr);

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(lw_cr)

`VTX_CHECKER_MODULE_END
