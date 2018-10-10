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

`VTX_CHECKER_MODULE_BEGIN(instr_gather_h)

wire [31:0] exp_addrs   [1:0];
assign exp_addrs[0] = vtx_instr_rs1 + `CRS2[15: 0];
assign exp_addrs[1] = vtx_instr_rs1 + `CRS2[31:16];

//
// gather_h
//
//  Note this set of checks is tied to the reference implementation of
//  scatter.h. This means all memory transactions happen in a deterministic
//  order.
//
`VTX_CHECK_INSTR_BEGIN(gather_h) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_ST_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_SAD);

    if(exp_addrs[0][0] || exp_addrs[1][0]) begin
    
        `VTX_ASSERT(vtx_instr_result == SCARV_COP_INSN_BAD_LAD);

    end else if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
    
        // If the instruction succeeds, check it wrote the right data out

        // 1st memory transaction
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == {exp_addrs[1][31:2],2'b00});
//        `VTX_ASSERT(vtx_mem_wdata_0== `CRD[31:24])
        
        // 0th memory transaction
        `VTX_ASSERT(vtx_mem_cen_1  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_1  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_1 == {exp_addrs[0][31:2],2'b00});
//        `VTX_ASSERT(vtx_mem_wdata_1== `CRD[23:16])

    end else if(vtx_instr_result == SCARV_COP_INSN_ST_ERR) begin
        
        // Remaining state implementation dependent.

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(gather_h)

`VTX_CHECKER_MODULE_END

