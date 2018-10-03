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

`VTX_CHECKER_MODULE_BEGIN(instr_sw_cr)

wire [31:0] sw_addr =
    vtx_instr_rs1 + 
    {{20{dec_arg_imm11hi[6]}},dec_arg_imm11hi,dec_arg_imm11lo};

//
// sw_cr
//
`VTX_CHECK_INSTR_BEGIN(sw_cr) 

    // Make sure it never gives the wrong error code.
    assert(vtx_instr_result != SCARV_COP_INSN_LD_ERR);
    assert(vtx_instr_result != SCARV_COP_INSN_BAD_LAD);

    // If the instruction succeeds, check it wrote the right data back
    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin

        assert(vtx_mem_cen_0  == 1'b1);
        assert(vtx_mem_wen_0  == 1'b1);
        assert(vtx_mem_addr_0 == sw_addr);
        assert(vtx_mem_wdata_0 == `CRS2);

    end else if(vtx_instr_result == SCARV_COP_INSN_LD_ERR) begin
        
        // Transaction should have started correctly.
        assert(vtx_mem_cen_0  == 1'b1);
        assert(vtx_mem_wen_0  == 1'b1);
        assert(vtx_mem_addr_0 == sw_addr);
        assert(vtx_mem_wdata_0 == `CRS2);
    
    end else if(vtx_instr_result == SCARV_COP_INSN_BAD_SAD) begin
        
        // No transaction should have occured.
        assert(vtx_mem_cen_0  == 1'b0);

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(sw_cr)

`VTX_CHECKER_MODULE_END
