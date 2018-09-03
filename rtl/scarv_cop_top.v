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
// module: scarv_cop_top
//
//  The top level module of the Crypto ISE co-processor.
//
module scarv_cop_top (

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
output wire             g_clk_req       , // Clock request
input  wire             g_resetn        , // Synchronous active low reset.

//
// Status Interface

// TBD


//
// CPU / COP Interface
input  wire             cpu_insn_req    , // Instruction request
output wire             cop_insn_ack    , // Instruction request acknowledge
input  wire             cpu_abort_req   , // Abort Instruction
input  wire [31:0]      cpu_insn_enc    , // Encoded instruction data
input  wire [31:0]      cpu_rs1         , // RS1 source data

output wire             cop_wen         , // COP write enable
output wire [ 4:0]      cop_waddr       , // COP destination register address
output wire [31:0]      cop_wdata       , // COP write data
output wire [ 2:0]      cop_result      , // COP execution result
output wire             cop_insn_rsp    , // COP instruction finished
input  wire             cpu_insn_ack    , // Instruction finish acknowledge

//
// Memory Interface
output wire             cop_mem_cen     , // Chip enable
output wire             cop_mem_wen     , // write enable
output wire [31:0]      cop_mem_addr    , // Read/write address (word aligned)
output wire [31:0]      cop_mem_wdata   , // Memory write data
input  wire [31:0]      cop_mem_rdata   , // Memory read data
output wire [ 3:0]      cop_mem_ben     , // Write Byte enable
input  wire             cop_mem_stall   , // Stall
input  wire             cop_mem_error     // Error

);


//
// BEGIN DUMMY CODE

reg dummy_ack = 0;
reg dummy_rsp = 0;

assign cop_insn_ack = dummy_ack;
assign cop_insn_rsp = dummy_rsp;

always @(posedge g_clk) dummy_ack <= !g_resetn ? 1'b0 : cpu_insn_req;

always @(posedge g_clk) begin
    if(!g_resetn) 
        dummy_rsp <= 1'b0;
    else if(dummy_rsp)
        dummy_rsp <= cpu_insn_ack ? 1'b1 : dummy_ack;
    else
        dummy_rsp <= dummy_ack;
end

// END DUMMY CODE
//

endmodule
