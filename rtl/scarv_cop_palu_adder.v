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
// This file contains several modules used to build the packed arithmetic
// adder block.
//


//
// module scarv_cop_palu_adder
//
//
module scarv_cop_palu_adder (
    input  wire [31:0] a ,  // LHS input
    input  wire [31:0] b ,  // RHS input
    input  wire [ 2:0] pw,  // Current operation pack width
    input  wire        ci,  // Carry in
    output wire [31:0] c ,  // Result
    output wire        co   // Carry out

);

`include "scarv_cop_common.vh"

genvar i;

wire [31:0] result_bits;
wire [32:0] carry_bits;
wire [31:0] carry_msk ;

assign carry_bits[0] = ci;
assign co            = carry_bits[32];
assign c             = result_bits[31:0];

wire   pw_1          = pw == SCARV_COP_PW_1 ; // 1  32-bit word
wire   pw_2          = pw == SCARV_COP_PW_2 ; // 2  16-bit halfwords
wire   pw_4          = pw == SCARV_COP_PW_4 ; // 4   8-bit bytes
wire   pw_8          = pw == SCARV_COP_PW_8 ; // 8   4-bit nibbles
wire   pw_16         = pw == SCARV_COP_PW_16; // 16  2-bit crumbs
wire   pw_1hot       = {
    pw_1 && !pw_16 && !pw_8 && !pw_4 && !pw_2   , 
    pw_2 && !pw_16 && !pw_8 && !pw_4            ,
    pw_4 && !pw_16 && !pw_8                     ,
    pw_8 && !pw_16                              ,
    pw_16                                       ,
    1'b1  
};

generate for(i = 0; i < 32; i = i + 1) begin

    wire [1:0] ir   = a[i]+b[i]+carry_bits[i];

    assign carry_msk[i]     = (i & pw_1hot) == 0;
    assign result_bits[i]   = ir[0];
    assign carry_bits [i+1] = ir[1] && carry_msk[i];

end endgenerate

endmodule
