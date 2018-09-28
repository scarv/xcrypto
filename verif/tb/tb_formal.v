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

//
// module: tb_formal
//
//  Top level testbench for the formal verification flow.
//
module tb_formal ();

wire   g_clk    ;  // Global clock
wire   g_clk_req;  // Clock request
wire   g_resetn ;  // Synchronous active low reset.


//
// DUT and model Interface Signals
//

//
// CPU / COP Interface
wire             cpu_insn_req    ; // Instruction request
wire             cop_insn_ack    ; // Instruction request acknowledge
wire             cpu_abort_req   ; // Abort Instruction
wire [31:0]      cop_insn_enc    ; // The encoded instruction to execute.
wire [31:0]      cpu_rs1         ; // RS1 source data

wire             cop_wen         ; // COP write enable
wire [ 4:0]      cop_waddr       ; // COP destination register address
wire [31:0]      cop_wdata       ; // COP write data
wire [ 2:0]      cop_result      ; // COP execution result
wire             cop_insn_rsp    ; // COP instruction finished
wire             cpu_insn_ack    ; // Instruction finish acknowledge

// Registerd versions of the DUT outputs for checking.
reg              p_cop_finish    ; // COP finish.
reg              p_cop_wen       ; // COP write enable
reg  [ 4:0]      p_cop_waddr     ; // COP destination register address
reg  [31:0]      p_cop_wdata     ; // COP write data
reg  [ 2:0]      p_cop_result    ; // COP execution result

`define FIFO(D,W,S,E) reg [W-1:0] fifo_``S [D-1:0];\
genvar gf_``S;\
always @(*) fifo_``S[0] = S; \
generate for(gf_``S = 1;gf_``S < D; gf_``S = gf_``S + 1) \
    always @(posedge g_clk) if(!g_resetn) fifo_``S[gf_``S] <= 0;\
        else if (E) fifo_``S[gf_``S] <= fifo_``S[gf_``S - 1];\
endgenerate

`FIFO(4, 5,cop_waddr ,cop_insn_finish)
`FIFO(4, 1,cop_wen   ,cop_insn_finish)
`FIFO(4,32,cop_wdata ,cop_insn_finish)
`FIFO(4, 3,cop_result,cop_insn_finish)

//
// Memory Interface
wire             cop_mem_cen     ; // Chip enable
wire             cop_mem_wen     ; // write enable
wire [31:0]      cop_mem_addr    ; // Read/write address (word aligned)
wire [31:0]      cop_mem_wdata   ; // Memory write data
wire [31:0]      cop_mem_rdata   ; // Memory read data
wire [ 3:0]      cop_mem_ben     ; // Write Byte enable
wire             cop_mem_stall   ; // Stall
wire             cop_mem_error   ; // Error

wire [31:0]      cop_random      ; // The most recent random sample
wire             cop_rand_sample ; // cop_random valid when this high.

//
// Model signals
wire cop_insn_valid  = cpu_insn_req && cop_insn_ack; // New input instruction
wire cop_insn_finish = cop_insn_rsp && cpu_insn_ack; // instr output valid.
wire grm_insn_valid  = cop_insn_finish;

// GRM finishes all instructions in one cycle, assuming all loads and
// stores triggered by that instruction have already completed.
reg  grm_insn_finish;
always @(posedge g_clk) grm_insn_finish<= grm_insn_valid;

wire [ 2:0]      grm_result      ; // Instruction execution result

wire [15:0]      grm_cprs_written; // CPR Registers read by instr
wire [15:0]      grm_cprs_read   ; // CPR Registers written by instr

wire             grm_rd_wen      ; // GPR Write Enable
wire [ 4:0]      grm_rd_addr     ; // GPR Write Address
wire [31:0]      grm_rd_data     ; // Data to write to GPR

`FIFO(4, 5,grm_rd_addr  , cop_insn_finish)
`FIFO(4, 1,grm_rd_wen   , cop_insn_finish)
`FIFO(4,32,grm_rd_data  , cop_insn_finish)
`FIFO(4, 3,grm_result   , cop_insn_finish)

// --------------- Assertions, Assumptions and Restrictions ------------

// Tie abort to zero for now
assign cpu_abort_req = 0;

assign cpu_insn_req = $anyseq;
assign cop_insn_enc = $anyseq;
assign cpu_rs1      = $anyseq;

assign cpu_insn_ack = $anyseq;

assign cop_mem_rdata= $anyseq;
assign cop_mem_stall= $anyseq;
assign cop_mem_error= $anyseq;

assign g_resetn     = $anyseq;
initial assume(g_resetn == 1'b0);

// ---------------------------------------------------------------------

//
// Runtime Checks
//
model_checks i_model_checks(
.g_clk        (g_clk            ), // Global clock
.g_clk_req    (g_clk_req        ), // Clock request
.g_resetn     (g_resetn         ), // Synchronous active low reset.

.dut_in_valid (cop_insn_valid   ), // Input Instruction valid
.dut_insn_enc (cop_insn_enc     ), // Encoded instruction data
.dut_rs1      (cpu_rs1          ), // RS1 source data

.grm_in_valid (grm_insn_finish  ), // Input Instruction valid
.grm_insn_enc (cop_insn_enc     ), // Encoded instruction data
.grm_rs1      (cpu_rs1          ), // RS1 source data

.dut_out_valid(cop_insn_finish  ), // Output of DUT valid.
.dut_result   (fifo_cop_result[1]), // Instruction execution result
.dut_rd_wen   (fifo_cop_wen   [1]), // GPR Write Enable
.dut_rd_addr  (fifo_cop_waddr [1]), // GPR Write Address
.dut_rd_data  (fifo_cop_wdata [1]), // Data to write to GPR

.grm_out_valid(cop_insn_finish    ), // Output of GRM valid.
.grm_result   (fifo_grm_result [0]), // Instruction execution result
.grm_rd_wen   (fifo_grm_rd_wen [0]), // GPR Write Enable
.grm_rd_addr  (fifo_grm_rd_addr[0]), // GPR Write Address
.grm_rd_data  (fifo_grm_rd_data[0])  // Data to write to GPR
);


//
// ISE Model
//
model_ise i_grm(
.g_clk           (g_clk           ), // Global clock
.g_clk_req       (g_clk_req       ), // Clock request
.g_resetn        (g_resetn        ), // Synchronous active low reset.
.cop_insn_valid  (grm_insn_valid  ), // Instruction valid
.cop_insn_enc    (cop_insn_enc    ), // Encoded instruction data
.cop_rs1         (cpu_rs1         ), // RS1 source data
.cop_result      (grm_result      ), // Instruction execution result
.cop_cprs_written(grm_cprs_written), // CPR Registers read by instr
.cop_cprs_read   (grm_cprs_read   ), // CPR Registers written by instr
.cop_rd_wen      (grm_rd_wen      ), // GPR Write Enable
.cop_rd_addr     (grm_rd_addr     ), // GPR Write Address
.cop_rd_data     (grm_rd_data     ), // Data to write to GPR
.cop_random      (cop_random      ), // Latest random sample value
.cop_rand_sample (cop_rand_sample ), // random sample value valid
.cop_mem_cen     (cop_mem_cen     ), // Chip enable
.cop_mem_wen     (cop_mem_wen     ), // write enable
.cop_mem_addr    (cop_mem_addr    ), // Read/write address (word aligned)
.cop_mem_wdata   (cop_mem_wdata   ), // Memory write data
.cop_mem_rdata   (cop_mem_rdata   ), // Memory read data
.cop_mem_ben     (cop_mem_ben     ), // Write Byte enable
.cop_mem_stall   (cop_mem_stall   ), // Stall
.cop_mem_error   (cop_mem_error   )  // Error
);


//
// DUT Instance
//
scarv_cop_top i_dut(
.g_clk         (g_clk        ) , // Global clock
.g_clk_req     (g_clk_req    ) , // Clock request
.g_resetn      (g_resetn     ) , // Synchronous active low reset.
.cpu_insn_req  (cpu_insn_req ) , // Instruction request
.cop_insn_ack  (cop_insn_ack ) , // Instruction request acknowledge
.cpu_abort_req (cpu_abort_req) , // Abort Instruction
.cpu_insn_enc  (cop_insn_enc ) , // Encoded instruction data
.cpu_rs1       (cpu_rs1      ) , // RS1 source data
.cop_wen       (cop_wen      ) , // COP write enable
.cop_waddr     (cop_waddr    ) , // COP destination register address
.cop_wdata     (cop_wdata    ) , // COP write data
.cop_result    (cop_result   ) , // COP execution result
.cop_insn_rsp  (cop_insn_rsp ) , // COP instruction finished
.cpu_insn_ack  (cpu_insn_ack ) , // Instruction finish acknowledge
.cop_random      (cop_random      ), // Latest random sample value
.cop_rand_sample (cop_rand_sample ), // random sample value valid
.cop_mem_cen   (cop_mem_cen  ) , // Chip enable
.cop_mem_wen   (cop_mem_wen  ) , // write enable
.cop_mem_addr  (cop_mem_addr ) , // Read/write address (word aligned)
.cop_mem_wdata (cop_mem_wdata) , // Memory write data
.cop_mem_rdata (cop_mem_rdata) , // Memory read data
.cop_mem_ben   (cop_mem_ben  ) , // Write Byte enable
.cop_mem_stall (cop_mem_stall) , // Stall
.cop_mem_error (cop_mem_error)   // Error
);


endmodule

