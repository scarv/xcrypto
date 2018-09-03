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
// module: monitor_cop_mem_if
//
//  Checker module for the COP memory interface
//
module monitor_cop_mem_if (

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
input  wire             g_clk_req       , // Clock request
input  wire             g_resten        , // Synchronous active low reset.

//
// Memory Interface
input  wire             cop_mem_cen     , // Chip enable
input  wire             cop_mem_wen     , // write enable
input  wire [31:0]      cop_mem_addr    , // Read/write address (word aligned)
input  wire [31:0]      cop_mem_wdata   , // Memory write data
input  wire [31:0]      cop_mem_rdata   , // Memory read data
input  wire [ 3:0]      cop_mem_ben     , // Write Byte enable
input  wire             cop_mem_stall   , // Stall
input  wire             cop_mem_error     // Error

);




endmodule

