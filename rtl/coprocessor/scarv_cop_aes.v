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
// module: scarv_cop_aes
//
//  Implements the AES instruction functionality for the co-processor
//
module scarv_cop_aes (
input  wire         g_clk           ,
input  wire         g_resetn        ,

input  wire         aes_ivalid      , // Valid instruction input
output wire         aes_idone       , // Instruction complete

input  wire [31:0]  aes_rs1         , // Source register 1
input  wire [31:0]  aes_rs2         , // Source register 2
input  wire [31:0]  aes_rs3         , // Source register 3

input  wire [31:0]  id_imm          , // Source immedate
input  wire [ 2:0]  id_pw           , // Pack width
input  wire [ 3:0]  id_class        , // Instruction class
input  wire [ 4:0]  id_subclass     , // Instruction subclass

output wire [ 3:0]  aes_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  aes_cpr_rd_wdata  // Writeback data
);

// FIXME: Implement the AES instructions.
assign aes_idone        = aes_ivalid;

assign aes_cpr_rd_ben   = 4'b0;
assign aes_cpr_rd_wdata = 0;

endmodule
