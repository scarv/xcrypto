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
// module: monitor_cpu_cop_if
//
//  Monitor for checking correctness of the cpu/cop interface.
//
module monitor_cpu_cop_if (

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
output wire             g_clk_req       , // Clock request
input  wire             g_resten        , // Synchronous active low reset.

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
input  wire             cpu_insn_ack      // Instruction finish acknowledge

);




endmodule

