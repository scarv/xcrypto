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

`VTX_CHECKER_MODULE_BEGIN(instr_scatter_b)

wire [3:0] exp_ben[3:0];
assign exp_ben[0] = 4'b0001;
assign exp_ben[1] = 4'b0010;
assign exp_ben[2] = 4'b0100;
assign exp_ben[3] = 4'b1000;

wire [31:0] exp_addrs [3:0];
assign exp_addrs[3] = vtx_instr_rs1 + `CRS2[ 7: 0];
assign exp_addrs[2] = vtx_instr_rs1 + `CRS2[15: 8];
assign exp_addrs[1] = vtx_instr_rs1 + `CRS2[23:16];
assign exp_addrs[0] = vtx_instr_rs1 + `CRS2[31:24];

wire [7:0] exp_wdata [3:0]; // Expected write data
assign exp_wdata[0] = `CRD[ 7: 0];
assign exp_wdata[1] = `CRD[15: 8];
assign exp_wdata[2] = `CRD[23:16];
assign exp_wdata[3] = `CRD[31:24];

wire [7:0] act_wdata [3:0]; // Actual write data

// Shift down so the byte being written is always compared
// later on. We don't care about the other bytes of the wdata signal.
assign act_wdata[3] = vtx_mem_wdata_0 >> (8*(exp_addrs[0][1:0]));
assign act_wdata[2] = vtx_mem_wdata_1 >> (8*(exp_addrs[1][1:0]));
assign act_wdata[1] = vtx_mem_wdata_2 >> (8*(exp_addrs[2][1:0]));
assign act_wdata[0] = vtx_mem_wdata_3 >> (8*(exp_addrs[3][1:0]));

//
// scatter_b
//
//  Note this set of checks is tied to the reference implementation of
//  scatter.b. This means all memory transactions happen in a deterministic
//  order.
//
`VTX_CHECK_INSTR_BEGIN(scatter_b) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_LD_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_LAD);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_SAD);

    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
    
        // If the instruction succeeds, check it wrote the right data out

        // 3rd memory transaction
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_ben_0  == exp_ben[exp_addrs[0][1:0]]);
        `VTX_ASSERT(vtx_mem_addr_0 == {exp_addrs[0][31:2],2'b00});
        `VTX_ASSERT(act_wdata[0] == exp_wdata[0]);
        
        // 2nd memory transaction
        `VTX_ASSERT(vtx_mem_cen_1  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_1  == 1'b1);
        `VTX_ASSERT(vtx_mem_ben_1  == exp_ben[exp_addrs[1][1:0]]);
        `VTX_ASSERT(vtx_mem_addr_1 == {exp_addrs[1][31:2],2'b00});
        `VTX_ASSERT(act_wdata[1] == exp_wdata[1]);

        // 1st memory transaction
        `VTX_ASSERT(vtx_mem_cen_2  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_2  == 1'b1);
        `VTX_ASSERT(vtx_mem_ben_2  == exp_ben[exp_addrs[2][1:0]]);
        `VTX_ASSERT(vtx_mem_addr_2 == {exp_addrs[2][31:2],2'b00});
        `VTX_ASSERT(act_wdata[2] == exp_wdata[2]);

        // 0th memory transaction
        `VTX_ASSERT(vtx_mem_cen_3  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_3  == 1'b1);
        `VTX_ASSERT(vtx_mem_ben_3  == exp_ben[exp_addrs[3][1:0]]);
        `VTX_ASSERT(vtx_mem_addr_3 == {exp_addrs[3][31:2],2'b00});
        `VTX_ASSERT(act_wdata[3] == exp_wdata[3]);

    end else if(vtx_instr_result == SCARV_COP_INSN_ST_ERR) begin
        
        // Remaining state implementation dependent.

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(scatter_b)

`VTX_CHECKER_MODULE_END
