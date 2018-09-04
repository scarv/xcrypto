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
// module: scarv_cop_malu
//
//  Combinatorial multi-precision arithmetic and shift module.
//
module scarv_cop_malu (
input  wire         malu_ivalid      , // Valid instruction input
input  wire         malu_idone       , // Instruction complete

input  wire [31:0]  malu_rs1         , // Source register 1
input  wire [31:0]  malu_rs2         , // Source register 2
input  wire [31:0]  malu_rs3         , // Source register 3

input  wire [31:0]  id_imm           , // Source immedate
input  wire [31:0]  id_class         , // Instruction class
input  wire [31:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  malu_cpr_rd_ben  , // Writeback byte enable
output wire [ 3:0]  malu_cpr_rd_wdata  // Writeback data
);



endmodule
