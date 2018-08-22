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
// module: model_ise
//
//  A behavioural model of the ISE
//
module model_ise(

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
output wire             g_clk_req       , // Clock request
input  wire             g_resten        , // Synchronous active low reset.

//
// Input instruction interface
input  wire             cop_insn_valid  , // Instruction valid
input  wire [31:0]      cop_insn_enc    , // Encoded instruction data
input  wire [31:0]      cop_rs1         , // RS1 source data

//
// Output modelling signals
output reg  [ 2:0]      cop_result        // Instruction execution result

);




endmodule

