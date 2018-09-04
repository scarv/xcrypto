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
// module: scarv_cop_palu
//
//  Combinatorial Packed arithmetic and shift module.
//
module scarv_cop_palu (
input  wire         palu_ivalid      , // Valid instruction input
output wire         palu_idone       , // Instruction complete

input  wire [31:0]  palu_rs1         , // Source register 1
input  wire [31:0]  palu_rs2         , // Source register 2
input  wire [31:0]  palu_rs3         , // Source register 3

input  wire [31:0]  id_imm           , // Source immedate
input  wire [31:0]  id_class         , // Instruction class
input  wire [31:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  palu_cpr_rd_ben  , // Writeback byte enable
output wire [ 3:0]  palu_cpr_rd_wdata  // Writeback data
);

// Purely combinatoral block.
assign palu_idone = palu_ivalid;



endmodule
