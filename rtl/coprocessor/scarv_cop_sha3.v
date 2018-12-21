
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
// module: scarv_cop_sha3
//
//  Implements the SHA3 instruction functionality for the co-processor
//
module scarv_cop_sha3 (
input  wire         g_clk           ,
input  wire         g_resetn        ,

input  wire         sha3_ivalid     , // Valid instruction input
output wire         sha3_idone      , // Instruction complete

input  wire [31:0]  sha3_rs1         , // Source register 1
input  wire [31:0]  sha3_rs2         , // Source register 2

input  wire [ 3:0]  id_class         , // Instruction class
input  wire [ 4:0]  id_subclass      , // Instruction subclass
input  wire [31:0]  id_imm           , // Immediate

output wire [ 3:0]  sha3_cpr_rd_ben  , // Writeback byte enable
output reg  [31:0]  sha3_cpr_rd_wdata  // Writeback data
);

// Commom field name and values.
`include "scarv_cop_common.vh"


assign sha3_idone      = sha3_ivalid;

wire sha3_xy  = sha3_ivalid && id_subclass == SCARV_COP_SCLASS_SHA3_XY;
wire sha3_x1  = sha3_ivalid && id_subclass == SCARV_COP_SCLASS_SHA3_X1;
wire sha3_x2  = sha3_ivalid && id_subclass == SCARV_COP_SCLASS_SHA3_X2;
wire sha3_x4  = sha3_ivalid && id_subclass == SCARV_COP_SCLASS_SHA3_X4;
wire sha3_yx  = sha3_ivalid && id_subclass == SCARV_COP_SCLASS_SHA3_YX;

assign sha3_cpr_rd_ben = 0;

wire [4:0] x = {2'b0,sha3_rs1[2:0]};
wire [4:0] y = {2'b0,sha3_rs2[2:0]};
wire [1:0] shamt = id_imm[7:6];

// Lookup table for values of X%5
wire [3:0] mod5_lut [35:0];

genvar i;
generate for (i = 0; i < 36; i = i + 1) begin
    assign mod5_lut[i] = (i%5);
end endgenerate

always @(*) begin

    if(sha3_xy) begin
        sha3_cpr_rd_wdata = (mod5_lut[x  ] + 5*(mod5_lut[y])) << shamt;
    end else if(sha3_x1) begin
        sha3_cpr_rd_wdata = (mod5_lut[x+1] + 5*(mod5_lut[y])) << shamt;
    end else if(sha3_x2) begin
        sha3_cpr_rd_wdata = (mod5_lut[x+2] + 5*(mod5_lut[y])) << shamt;
    end else if(sha3_x4) begin
        sha3_cpr_rd_wdata = (mod5_lut[x+4] + 5*(mod5_lut[y])) << shamt;
    end else if(sha3_yx) begin
        sha3_cpr_rd_wdata = (mod5_lut[y  ] + 5*(mod5_lut[2*x+3*y])) << shamt;
    end else begin
        sha3_cpr_rd_wdata = 0;
    end

end

endmodule
