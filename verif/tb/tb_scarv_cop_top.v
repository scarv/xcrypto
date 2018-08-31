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
// module: tb_scarv_cop_top
//
//  Top level testbench for the constrained random and directed testing flow.
//
module tb_scarv_cop_top();

reg    g_clk    ;  // Global clock
wire   g_clk_req;  // Clock request
reg    g_resetn ;  // Synchronous active low reset.

//
// Clock and reset generation 
//
initial g_resetn = 0;
initial g_clk    = 0;

initial #80 g_resetn = 1;
always @(g_clk) #20 g_clk <= !g_clk;

reg [10:0] clk_counter = 0;
always @(posedge g_clk) begin
    clk_counter = clk_counter + 1;

    if(clk_counter > TB_MAX_CYCLES) begin
        $finish;
    end
end

integer TB_MAX_CYCLES = 100;
reg [255*8:0] wavesfile;    // Where to dump VCD wave files
reg [255*8:0] imemfile;     // Where to load a test vector from.

initial begin
    
    if($value$plusargs("IMEM=%s",imemfile)) begin
        $display("IMEM :    %s", imemfile);
    end
    
    if($value$plusargs("TIMEOUT=%d",TB_MAX_CYCLES)) begin
        $display("TIMEOUT : %d", TB_MAX_CYCLES);
    end
    
    if($value$plusargs("WAVES=%s",wavesfile)) begin
    end else begin
        wavesfile="work/waves-icarus.vcd";
    end
    
    $dumpfile(wavesfile);
    $dumpvars(0,tb_scarv_cop_top);
end

//
// Simulation instruction memory
//

reg  [31:0] sim_instr_mem [64:0];
reg  [31:0] sim_instr_cnt;
wire [ 5:0] n_sim_instr_cnt = sim_instr_cnt + 1;

//
// DUT interface stimulus
//

// Which instruction to feed to the DUT next.
wire [31:0] cop_insn_enc = sim_instr_mem[sim_instr_cnt];

// Increment the instruction counter each time an instruction is accepted
// by the COP.
always @(posedge g_clk) begin
    if(!g_resetn) begin
        sim_instr_cnt <= 0;
    end else if(cop_insn_valid) begin
        sim_instr_cnt <= n_sim_instr_cnt;;
    end
end

// Tie abort to zero for now
initial cpu_abort_req = 0;

// Random instruction dispatch to the DUT
always @(posedge g_clk) begin
    if(!g_resetn) begin
        cpu_insn_req <= 1'b0;

    end else if( cpu_insn_req &&  cop_insn_ack) begin
        cpu_insn_req <= $random & 1;
    
    end else if( cpu_insn_req && !cop_insn_ack) begin
        cpu_insn_req <= 1'b1;

    end else if(!cpu_insn_req &&  cop_insn_ack) begin
        cpu_insn_req <= $random & 1;

    end else if(!cpu_insn_req && !cop_insn_ack) begin
        cpu_insn_req <= $random & 1;

    end
end

// Random RS1 Read data
initial cpu_rs1 = $random;
always @(posedge g_clk) if(cop_insn_valid) cpu_rs1 <= $random;

// Random accepting of instruction results.
always @(posedge g_clk) begin
    if(!g_resetn) begin
        cpu_insn_ack <= 1'b0;
    end else if (cop_insn_rsp && ($random & 1)) begin
        cpu_insn_ack <= 1'b1;
    end else begin
        cpu_insn_ack <= 1'b0;
    end
end

//
// DUT and model Interface Signals
//

//
// CPU / COP Interface
reg              cpu_insn_req    ; // Instruction request
wire             cop_insn_ack    ; // Instruction request acknowledge
reg              cpu_abort_req   ; // Abort Instruction
reg  [31:0]      cpu_rs1         ; // RS1 source data

wire             cop_wen         ; // COP write enable
wire [ 4:0]      cop_waddr       ; // COP destination register address
wire [31:0]      cop_wdata       ; // COP write data
wire [ 2:0]      cop_result      ; // COP execution result
wire             cop_insn_rsp    ; // COP instruction finished
reg              cpu_insn_ack    ; // Instruction finish acknowledge

//
// Memory Interface
wire             cop_mem_cen     ; // Chip enable
wire             cop_mem_wen     ; // write enable
wire [31:0]      cop_mem_addr    ; // Read/write address (word aligned)
wire [31:0]      cop_mem_wdata   ; // Memory write data
reg  [31:0]      cop_mem_rdata   ; // Memory read data
wire [ 3:0]      cop_mem_ben     ; // Write Byte enable
reg              cop_mem_stall   ; // Stall
reg              cop_mem_error   ; // Error

//
// Model signals
wire             cop_insn_valid  = cpu_insn_req && cop_insn_ack;
wire             cop_insn_finish = cop_insn_rsp && cpu_insn_ack;

wire [ 2:0]      grm_result      ; // Instruction execution result

wire [15:0]      grm_cprs_written; // CPR Registers read by instr
wire [15:0]      grm_cprs_read   ; // CPR Registers written by instr

wire             grm_rd_wen      ; // GPR Write Enable
wire [ 4:0]      grm_rd_addr     ; // GPR Write Address
wire [31:0]      grm_rd_data     ; // Data to write to GPR

//
// Runtime Checks
//


//
// ISE Model
//
model_ise i_grm(
.g_clk           (g_clk           ), // Global clock
.g_clk_req       (g_clk_req       ), // Clock request
.g_resetn        (g_resetn        ), // Synchronous active low reset.
.cop_insn_valid  (cop_insn_valid  ), // Instruction valid
.cop_insn_enc    (cop_insn_enc    ), // Encoded instruction data
.cop_rs1         (cpu_rs1         ), // RS1 source data
.cop_result      (grm_result      ), // Instruction execution result
.cop_cprs_written(grm_cprs_written), // CPR Registers read by instr
.cop_cprs_read   (grm_cprs_read   ), // CPR Registers written by instr
.cop_rd_wen      (grm_rd_wen      ), // GPR Write Enable
.cop_rd_addr     (grm_rd_addr     ), // GPR Write Address
.cop_rd_data     (grm_rd_data     ), // Data to write to GPR
.cop_mem_cen_0   (                ), // Memory transaction 0 enable
.cop_mem_wen_0   (                ), // Transaction 0 write enable
.cop_mem_ben_0   (                ), // Transaction byte enable
.cop_mem_addr_0  (                ), // Transaction 0 address
.cop_mem_wdata_0 (                ), // Transaction 0 write enable
.cop_mem_rdata_0 (0               ), // Transaction 0 write enable
.cop_mem_cen_1   (                ), // Memory transaction 1 enable
.cop_mem_wen_1   (                ), // Transaction 1 write enable
.cop_mem_ben_1   (                ), // Transaction byte enable
.cop_mem_addr_1  (                ), // Transaction 1 address
.cop_mem_wdata_1 (                ), // Transaction 1 write enable
.cop_mem_rdata_1 (0               ), // Transaction 1 write enable
.cop_mem_cen_2   (                ), // Memory transaction 1 enable
.cop_mem_wen_2   (                ), // Transaction 2 write enable
.cop_mem_ben_2   (                ), // Transaction byte enable
.cop_mem_addr_2  (                ), // Transaction 2 address
.cop_mem_wdata_2 (                ), // Transaction 2 write enable
.cop_mem_rdata_2 (0               ), // Transaction 2 write enable
.cop_mem_cen_3   (                ), // Memory transaction 1 enable
.cop_mem_wen_3   (                ), // Transaction 3 write enable
.cop_mem_ben_3   (                ), // Transaction byte enable
.cop_mem_addr_3  (                ), // Transaction 3 address
.cop_mem_wdata_3 (                ), // Transaction 3 write enable
.cop_mem_rdata_3 (0               )  // Transaction 3 write enable
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

