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

`VTX_CHECKER_MODULE_BEGIN(instr_ld_bu)

wire [31:0] lb_addr = vtx_instr_rs1 + {{21{dec_arg_imm11[10]}},dec_arg_imm11};

wire [ 7:0] lb_rdata = 
    lb_addr[1:0] == 2'b00 ? vtx_mem_rdata_0[ 7: 0] :
    lb_addr[1:0] == 2'b01 ? vtx_mem_rdata_0[15: 8] :
    lb_addr[1:0] == 2'b10 ? vtx_mem_rdata_0[23:16] :
    lb_addr[1:0] == 2'b11 ? vtx_mem_rdata_0[31:24] :
                            0                      ;

// Loaded byte destination byte
wire [1:0] lb_db = {dec_arg_cc, dec_arg_cd};

//
// ld_bu
//
`VTX_CHECK_INSTR_BEGIN(ld_bu) 

    // Make sure it never gives the wrong error code.
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_ST_ERR);
    `VTX_ASSERT(vtx_instr_result != SCARV_COP_INSN_BAD_SAD);

    if(vtx_instr_result == SCARV_COP_INSN_SUCCESS) begin

        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == {lb_addr[31:2],2'b0});

        // Check that the loaded byte value went to the correct byte of
        // the destination CPR register.
        if(lb_db == 2'b00) begin

            // If h==b==0 then blank the top bytes of the register.
            `VTX_ASSERT_CRD_VALUE_IS(
                {24'b0,lb_rdata}
            )

        end else if(lb_db == 2'b01) begin

            `VTX_ASSERT_CRD_VALUE_IS(
                {vtx_crd_val_pre[31:16],lb_rdata,vtx_crd_val_pre[ 7: 0]}
            )

        end else if(lb_db == 2'b10) begin

            `VTX_ASSERT_CRD_VALUE_IS(
                {vtx_crd_val_pre[31:24],lb_rdata,vtx_crd_val_pre[15: 0]}
            )

        end else if(lb_db == 2'b11) begin
        
            `VTX_ASSERT_CRD_VALUE_IS(
                {lb_rdata, vtx_crd_val_pre[23:0]}
            )

        end

    end else if(vtx_instr_result == SCARV_COP_INSN_LD_ERR) begin
        
        // Transaction should have started correctly.
        `VTX_ASSERT(vtx_mem_cen_0  == 1'b1);
        `VTX_ASSERT(vtx_mem_wen_0  == 1'b0);
        `VTX_ASSERT(vtx_mem_addr_0 == {lb_addr[31:2],2'b0});

    end

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(ld_bu)

`VTX_CHECKER_MODULE_END

