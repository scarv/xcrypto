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

`VTX_CHECKER_MODULE_BEGIN(instr_scatter_h)

wire [3:0] exp_ben      [1:0];
assign exp_ben[0]   = 4'b0011;
assign exp_ben[1]   = 4'b1100;

wire [31:0] exp_addrs   [1:0];
assign exp_addrs[0] = vtx_instr_rs1 + `CRS2[15: 0];
assign exp_addrs[1] = vtx_instr_rs1 + `CRS2[31:16];

//
// scatter_h
//
//  Note this set of checks is tied to the reference implementation of
//  scatter.b. This means all memory transactions happen in a deterministic
//  order.
//
`VTX_CHECK_INSTR_BEGIN(scatter_h) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_LD_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_LAD);

    if(exp_addrs[0][0] || exp_addrs[1][0]) begin
    
        `VTX_ASSERT(vtx_instr_result == SCARV_COP_INSN_BAD_SAD);

    end else if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
    
        // If the instruction succeeds, check it wrote the right data out

        // 1st memory transaction
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_ben_0  == exp_ben[exp_addrs[1][1:0]]);
        `VTX_ASSERT(vtx_mem_addr_0 == {exp_addrs[1][31:2],2'b00});
//        `VTX_ASSERT(vtx_mem_wdata_0== `CRD[31:24])
        
        // 0th memory transaction
        `VTX_ASSERT(vtx_mem_cen_1  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_1  == 1'b1);
        `VTX_ASSERT(vtx_mem_ben_1  == exp_ben[exp_addrs[0][1:0]]);
        `VTX_ASSERT(vtx_mem_addr_1 == {exp_addrs[0][31:2],2'b00});
//        `VTX_ASSERT(vtx_mem_wdata_1== `CRD[23:16])

    end else if(vtx_instr_result == SCARV_COP_INSN_ST_ERR) begin
        
        // Remaining state implementation dependent.

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(scatter_h)

`VTX_CHECKER_MODULE_END

