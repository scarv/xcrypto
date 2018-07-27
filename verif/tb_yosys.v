
//
// University of Brisol SCARV Project
//


//
//  module: tb_yosys
//
//      Formal testbench for the main co-processor module.
//
module tb_yosys();

localparam DEC_ISE_OPCODE   = 7'b0101011;

localparam DEC_F3_SB_B      = 3'b000;   // SB.B instruction F3 field.
localparam DEC_F3_R         = 3'b001;   // R-type instruction F3 field.
localparam DEC_F3_LB_B      = 3'b010;   // LB.B instruction F3 field.
localparam DEC_F3_LB_BK     = 3'b011;   // LB.BK instruction F3 field.

localparam DEC_F7_XOR_RB    = 7'b0000000; // XOR.RB encoding for f7 field
localparam DEC_F7_XOR_RBK   = 7'b0000001; // XOR.RBK    ""
localparam DEC_F7_AND_RB    = 7'b0000010; // AND.RB     ""
localparam DEC_F7_AND_RBK   = 7'b0000011; // AND.RBK    ""
localparam DEC_F7_OR_RB     = 7'b0000100; // OR.RB      ""
localparam DEC_F7_OR_RBK    = 7'b0000101; // OR.RBK     ""


reg clk;
reg resetn;

//
// DUT interface wires
//

wire        clk_req         ; // Block clock request
wire        dut_clk = clk & (clk_req || !resetn);

wire        cop_req         = $anyseq; // COP request valid
wire        cop_acc         ; // COP request accept
wire        cop_rsp         ; // COP response valid
wire [31:0] cop_instr_in    = $anyseq; // Input instruction word
wire [31:0] cop_rs1         = $anyseq; // Input source register 1
wire [31:0] cop_rs2         = $anyseq; // Input source register 2

wire [ 2:0] cop_rd_byte     ; // Output destination byte / register.
wire [ 4:0] cop_rd          ; // Output destination register.
wire [31:0] cop_wdata       ; // Output result writeback data.
wire        cop_wen         ; // Output result write enable.

wire        cop_mem_ld_error; // Memory error on load.
wire        cop_mem_st_error; // Memory error on store.

wire        cop_mem_cen     ; // COP memory if chip enable.
wire        cop_mem_stall   = $anyseq; // COP memory if stall
wire        cop_mem_error   = $anyseq; // COP memory if error
wire        cop_mem_wen     ; // COP memory if write enable.
wire [ 3:0] cop_mem_ben     ; // COP memory write byte enable.
wire [31:0] cop_mem_wdata   ; // COP memory if write data
wire [31:0] cop_mem_rdata   = $anyseq; // COP memory if read data
wire [31:0] cop_mem_addr    ; // COP memory if address

//
// Formal checks.
//

initial assume(resetn == 1'b0);

// Don't issue requests during a reset.
always @(posedge clk) assume(!(resetn && cop_req));

always @(posedge clk) if(resetn) begin

    if(cop_req == 1'b0) begin
        // If there is no request, the module should do nothing!
        assert(cop_mem_cen == 1'b0);
        assert(cop_wen     == 1'b0);
        assert(cop_rsp     == 1'b0);
        assert(cop_acc     == 1'b0);

        if ($stable(cop_req) && $stable(resetn)) begin
            assert($stable(cop_mem_addr ));
            assert($stable(cop_mem_wdata));
            assert($stable(cop_mem_ben  ));
            assert($stable(cop_wdata    ));
            assert($stable(cop_wen      ));
        end
    end


    if(cop_req == 1'b1) begin
        // There is an active request.

        if(cop_instr_in[ 6: 0] == DEC_ISE_OPCODE &&
           cop_instr_in[14:12] == DEC_F3_R) begin
            // All R type instructions finish immediately
            assert(cop_acc == 1'b1);
            assert(cop_rsp == 1'b1);
        end
        
        if(cop_instr_in[ 6: 0] == DEC_ISE_OPCODE &&
           cop_instr_in[14:12] != DEC_F3_R) begin
            // All load/store instructions take at least one cycle to
            // finish.
            assert(cop_acc == 1'b1);

            if(!$stable(cop_req)) begin
                assert(cop_rsp == 1'b0);
            end else begin
                assert(cop_rsp == !cop_mem_stall);
            end
        end


    end

end else begin
    // We are in reset
    assume(cop_req == 1'b0);
end


//
// DUT instantiation
//

rop_ba_cop i_dut (
.clk             (dut_clk         ), // Global clock
.clk_req         (clk_req         ), // Block clock request
.resetn          (resetn          ), // Active low sychronous reset.
.cop_req         (cop_req         ), // COP request valid
.cop_acc         (cop_acc         ), // COP request accept
.cop_rsp         (cop_rsp         ), // COP response valid
.cop_instr_in    (cop_instr_in    ), // Input instruction word
.cop_rs1         (cop_rs1         ), // Input source register 1
.cop_rs2         (cop_rs2         ), // Input source register 2
.cop_rd_byte     (cop_rd_byte     ), // Output destination byte / register.
.cop_rd          (cop_rd          ), // Output destination register.
.cop_wdata       (cop_wdata       ), // Output result writeback data.
.cop_wen         (cop_wen         ), // Output result write enable.
.cop_mem_ld_error(cop_mem_ld_error), // Memory error on load.
.cop_mem_st_error(cop_mem_st_error), // Memory error on store.
.cop_mem_cen     (cop_mem_cen     ), // COP memory if chip enable.
.cop_mem_stall   (cop_mem_stall   ), // COP memory if stall
.cop_mem_error   (cop_mem_error   ), // COP memory if error
.cop_mem_wen     (cop_mem_wen     ), // COP memory if write enable.
.cop_mem_ben     (cop_mem_ben     ), // COP memory write byte enable.
.cop_mem_wdata   (cop_mem_wdata   ), // COP memory if write data
.cop_mem_rdata   (cop_mem_rdata   ), // COP memory if read data
.cop_mem_addr    (cop_mem_addr    )  // COP memory if address
);

endmodule


