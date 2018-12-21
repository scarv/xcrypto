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

//
// module: tb_formal
//
//  Top level testbench for the formal verification flow.
//
module tb_formal (

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
input  wire             g_resetn        , // Synchronous active low reset.

//
// CPU / COP Interface
input  wire             cpu_insn_req    , // Instruction request
input  wire [31:0]      cpu_insn_enc    , // Encoded instruction data
input  wire [31:0]      cpu_rs1         , // RS1 source data
input  wire [31:0]      cpu_rs2         , // RS2 source data

input  wire             cpu_insn_ack    , // Instruction finish acknowledge

//
// Memory Interface
input  wire [31:0]      cop_mem_rdata   , // Memory read data
input  wire             cop_mem_stall   , // Stall
input  wire             cop_mem_error     // Error


);

// ----------------------------------------------------------------------

wire        g_clk_req       ; // Clock request
wire        cop_insn_ack    ; // Instruction request acknowledge

wire [31:0] cop_random      ; // The most recent random sample
wire        cop_rand_sample ; // cop_random valid when this high.

wire        cop_wen         ; // COP write enable
wire [ 4:0] cop_waddr       ; // COP destination register address
wire [31:0] cop_wdata       ; // COP write data
wire [ 2:0] cop_result      ; // COP execution result
wire        cop_insn_rsp    ; // COP instruction finished

wire        cop_mem_cen     ; // Chip enable
wire        cop_mem_wen     ; // write enable
wire [31:0] cop_mem_addr    ; // Read/write address (word aligned)
wire [31:0] cop_mem_wdata   ; // Memory write data
wire [ 3:0] cop_mem_ben     ; // Write Byte enable


wire[31:0] vtx_cprs_snoop   [15:0]; // Monitor ports for the register values

// ----------------------------------------------------------------------


//
// DUT Instance
//
scarv_cop_top i_dut(
.g_clk         (g_clk        ) , // Global clock
.g_clk_req     (g_clk_req    ) , // Clock request
.g_resetn      (g_resetn     ) , // Synchronous active low reset.
`VTX_REGISTER_PORTS_CON(cprs_snoop, vtx_cprs_snoop)
.cpu_insn_req  (cpu_insn_req ) , // Instruction request
.cop_insn_ack  (cop_insn_ack ) , // Instruction request acknowledge
.cpu_insn_enc  (cpu_insn_enc ) , // Encoded instruction data
.cpu_rs1       (cpu_rs1      ) , // RS1 source data
.cpu_rs2       (cpu_rs2      ) , // RS1 source data
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

//
// Formal top level abstraction logic instance.
//
fml_top i_fml_top(
.g_clk         (g_clk        ) , // Global clock
.g_clk_req     (g_clk_req    ) , // Clock request
.g_resetn      (g_resetn     ) , // Synchronous active low reset.
`VTX_REGISTER_PORTS_CON(cprs_snoop, vtx_cprs_snoop)
.cpu_insn_req  (cpu_insn_req ) , // Instruction request
.cop_insn_ack  (cop_insn_ack ) , // Instruction request acknowledge
.cpu_insn_enc  (cpu_insn_enc ) , // Encoded instruction data
.cpu_rs1       (cpu_rs1      ) , // RS1 source data
.cpu_rs2       (cpu_rs2      ) , // RS1 source data
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


