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
// module: scarv_cop_rng
//
//  Random number generator block.
//
module scarv_cop_rng (
input  wire         rng_ivalid       , // Valid instruction input
output wire         rng_idone        , // Instruction complete

input  wire [31:0]  rng_rs1          , // Source register 1

input  wire [31:0]  id_imm           , // Source immedate
input  wire [31:0]  id_class         , // Instruction class
input  wire [31:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  rng_cpr_rd_ben   , // Writeback byte enable
output wire [ 3:0]  rng_cpr_rd_wdata  // Writeback data
);

assign rng_cpr_rd_ben = 0;
assign rng_cpr_rd_wdata = 0;
assign rng_idone = 0;

endmodule
