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

`VTX_CHECKER_MODULE_BEGIN(instr_st_h)

wire [31:0] sh_addr =
    vtx_instr_rs1 + 
    {{21{dec_arg_imm11hi[6]}},dec_arg_imm11hi,dec_arg_imm11lo};

wire [15:0] sh_wdata = dec_arg_cc ? `CRS2[31:16] : `CRS2[15:0];

//
// st_h
//
`VTX_CHECK_INSTR_BEGIN(st_h) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_LD_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_LAD);

    if(sh_addr[0]) begin

        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_BAD_SAD)

    end else if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin
    
        // If the instruction succeeds, check it wrote the right data

        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_addr_0 == {sh_addr[31:2],2'b00});
        
        if(sh_addr[1]) begin
            `VTX_ASSERT(vtx_mem_wdata_0[31:16] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b1100);
        end else begin
            `VTX_ASSERT(vtx_mem_wdata_0[15: 0] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b0011);
        end

    end else if(vtx_instr_result == SCARV_COP_INSN_ST_ERR) begin
        
        // Transaction should have started correctly.
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_addr_0 == {sh_addr[31:2],2'b00});
        
        if(sh_addr[1]) begin
            `VTX_ASSERT(vtx_mem_wdata_0[31:16] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b1100);
        end else begin
            `VTX_ASSERT(vtx_mem_wdata_0[15: 0] == sh_wdata);
            `VTX_ASSERT(vtx_mem_ben_0          == 4'b0011);
        end

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(st_h)

`VTX_CHECKER_MODULE_END
