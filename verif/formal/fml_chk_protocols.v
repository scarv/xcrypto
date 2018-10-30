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


`VTX_CHECKER_MODULE_BEGIN(protocols)

reg [7:0]   insn_in;
reg [7:0]   insn_out;

wire [7:0]  n_insn_in = insn_in + (vtx_cpu_req && vtx_cop_ack);
wire [7:0]  n_insn_out= insn_out+ (vtx_cpu_ack && vtx_cop_rsp);

always @(posedge `VTX_CLK_NAME) if(!vtx_reset) begin
    insn_in  <= 0;
    insn_out <= 0;
end else begin
    insn_in  <= n_insn_in;
    insn_out <= n_insn_out;
end

`VTX_CHECK_BEGIN(correct_insn_io_protocol)

    // Instructions in == instructions out
    `VTX_ASSERT((insn_in == insn_out) || (insn_in == (insn_out+1)));

    // Outputs should be stable while vtx_cop_rsp is high and vtx_cpu_ack
    // is low.
    if($past(vtx_cop_rsp && !vtx_cpu_ack)) begin
        `VTX_ASSERT($stable(vtx_cop_rsp     ));
        `VTX_ASSERT($stable(vtx_instr_result));
        `VTX_ASSERT($stable(vtx_instr_wdata ));
        `VTX_ASSERT($stable(vtx_instr_waddr ));
        `VTX_ASSERT($stable(vtx_instr_wen   ));
    end

`VTX_CHECK_END(correct_insn_io_protocol)

`VTX_CHECKER_MODULE_END
