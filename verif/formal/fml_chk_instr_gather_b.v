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

`VTX_CHECKER_MODULE_BEGIN(instr_gather_b)

wire [31:0] exp_addrs [3:0];
assign exp_addrs[3] = (vtx_instr_rs1 + `CRS2[ 7: 0]);
assign exp_addrs[2] = (vtx_instr_rs1 + `CRS2[15: 8]);
assign exp_addrs[1] = (vtx_instr_rs1 + `CRS2[23:16]);
assign exp_addrs[0] = (vtx_instr_rs1 + `CRS2[31:24]);

wire [7:0] exp_rdata [3:0]; // Expected read data to be written to CRD
assign exp_rdata[0] = vtx_mem_rdata_3 >> (8*(exp_addrs[3][1:0]));
assign exp_rdata[1] = vtx_mem_rdata_2 >> (8*(exp_addrs[2][1:0]));
assign exp_rdata[2] = vtx_mem_rdata_1 >> (8*(exp_addrs[1][1:0]));
assign exp_rdata[3] = vtx_mem_rdata_0 >> (8*(exp_addrs[0][1:0]));

//
// gather_b
//
//  Note this set of checks is tied to the reference implementation of
//  gather.b. This means all memory transactions happen in a deterministic
//  order.
//
`VTX_CHECK_INSTR_BEGIN(gather_b) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_ST_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_LAD);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_SAD);

    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
    
        // If the instruction succeeds, check it wrote the right data out

        // 3rd memory transaction
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == (exp_addrs[0] & 32'hFFFF_FFFC));
        `VTX_ASSERT(exp_rdata[0] == vtx_crd_val_post[ 7: 0]);
        
        // 2nd memory transaction
        `VTX_ASSERT(vtx_mem_cen_1  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_1  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_1 == (exp_addrs[1] & 32'hFFFF_FFFC));
        `VTX_ASSERT(exp_rdata[1] == vtx_crd_val_post[15: 8]);

        // 1st memory transaction
        `VTX_ASSERT(vtx_mem_cen_2  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_2  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_2 == (exp_addrs[2] & 32'hFFFF_FFFC));
        `VTX_ASSERT(exp_rdata[2] == vtx_crd_val_post[23:16]);

        // 0th memory transaction
        `VTX_ASSERT(vtx_mem_cen_3  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_3  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_3 == (exp_addrs[3] & 32'hFFFF_FFFC));
        `VTX_ASSERT(exp_rdata[3] == vtx_crd_val_post[31:24]);

    end else if(vtx_instr_result == SCARV_COP_INSN_ST_ERR) begin
        
        // Remaining state implementation dependent.

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(gather_b)

`VTX_CHECKER_MODULE_END
