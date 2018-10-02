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
// module scarv_cop_palu_shifter
//
//
module scarv_cop_palu_shifter(
    input  wire [31:0] a    , // LHS input
    input  wire [ 5:0] shamt, // RHS input
    input  wire [ 2:0] pw   , // Current operation pack width
    input  wire        sl   , // shift left / n shift right
    input  wire        r    , // rotate / n shift
    output wire [31:0] c      // Result
);

`include "scarv_cop_common.vh"

wire   pw_1          = pw == SCARV_COP_PW_1 ; // 1  32-bit word
wire   pw_2          = pw == SCARV_COP_PW_2 ; // 2  16-bit halfwords
wire   pw_4          = pw == SCARV_COP_PW_4 ; // 4   8-bit bytes
wire   pw_8          = pw == SCARV_COP_PW_8 ; // 8   4-bit nibbles
wire   pw_16         = pw == SCARV_COP_PW_16; // 16  2-bit crumbs

wire [63:0] shin = {r ? a : 32'b0,  a};

wire [31:0] result_1 ;
wire [31:0] result_2 ;
wire [31:0] result_4 ;
wire [31:0] result_8 ;
wire [31:0] result_16;

assign c = 
    {32{pw_1 }}  & result_1  |
    {32{pw_2 }}  & result_2  |
    {32{pw_4 }}  & result_4  |
    {32{pw_8 }}  & result_8  |
    {32{pw_16}}  & result_16 ;

assign result_1 = sl ? a << shamt : shin >> shamt;

`define PACKSHIFT(HI,LO, WIDTH) \
    sl ? a[HI:LO] << shamt : \
    {r ? {32/WIDTH{shin[HI:LO]}} : WIDTH'b0, shin[HI:LO]} >> shamt

wire [31:0] result_2_1   = `PACKSHIFT(31, 16, 16);
wire [31:0] result_2_0   = `PACKSHIFT(15,  0, 16);

wire [15:0] result_4_3   = `PACKSHIFT(31, 24, 8 );
wire [15:0] result_4_2   = `PACKSHIFT(23, 16, 8 );
wire [15:0] result_4_1   = `PACKSHIFT(15,  8, 8 );
wire [15:0] result_4_0   = `PACKSHIFT( 7,  0, 8 );

wire [ 7:0] result_8_7   = `PACKSHIFT(31, 28, 4 );
wire [ 7:0] result_8_6   = `PACKSHIFT(27, 24, 4 );
wire [ 7:0] result_8_5   = `PACKSHIFT(23, 20, 4 );
wire [ 7:0] result_8_4   = `PACKSHIFT(19, 16, 4 );
wire [ 7:0] result_8_3   = `PACKSHIFT(15, 12, 4 );
wire [ 7:0] result_8_2   = `PACKSHIFT(11,  8, 4 );
wire [ 7:0] result_8_1   = `PACKSHIFT( 7,  4, 4 );
wire [ 7:0] result_8_0   = `PACKSHIFT( 3,  0, 4 );

wire [ 3:0] result_16_15 = `PACKSHIFT(31, 30, 2 );
wire [ 3:0] result_16_14 = `PACKSHIFT(29, 28, 2 );
wire [ 3:0] result_16_13 = `PACKSHIFT(27, 26, 2 );
wire [ 3:0] result_16_12 = `PACKSHIFT(25, 24, 2 );
wire [ 3:0] result_16_11 = `PACKSHIFT(23, 22, 2 );
wire [ 3:0] result_16_10 = `PACKSHIFT(21, 20, 2 );
wire [ 3:0] result_16_9  = `PACKSHIFT(19, 18, 2 );
wire [ 3:0] result_16_8  = `PACKSHIFT(17, 16, 2 );
wire [ 3:0] result_16_7  = `PACKSHIFT(15, 14, 2 );
wire [ 3:0] result_16_6  = `PACKSHIFT(13, 12, 2 );
wire [ 3:0] result_16_5  = `PACKSHIFT(11, 10, 2 );
wire [ 3:0] result_16_4  = `PACKSHIFT( 9,  8, 2 );
wire [ 3:0] result_16_3  = `PACKSHIFT( 7,  6, 2 );
wire [ 3:0] result_16_2  = `PACKSHIFT( 5,  4, 2 );
wire [ 3:0] result_16_1  = `PACKSHIFT( 3,  2, 2 );
wire [ 3:0] result_16_0  = `PACKSHIFT( 1,  0, 2 );

assign result_2 = {
result_2_1[15:0],
result_2_0[15:0] 
};                                           
                                             
assign result_4 = {                          
result_4_3[7:0],
result_4_2[7:0],
result_4_1[7:0],
result_4_0[7:0] 
};                                           
                                             
assign result_8 = {                          
result_8_7[3:0],
result_8_6[3:0],
result_8_5[3:0],
result_8_4[3:0],
result_8_3[3:0],
result_8_2[3:0],
result_8_1[3:0],
result_8_0[3:0] 
};                                           
                                             
assign result_16 = {                         
result_16_15[1:0],
result_16_14[1:0],
result_16_13[1:0],
result_16_12[1:0],
result_16_11[1:0],
result_16_10[1:0],
result_16_9 [1:0],
result_16_8 [1:0],
result_16_7 [1:0],
result_16_6 [1:0],
result_16_5 [1:0],
result_16_4 [1:0],
result_16_3 [1:0],
result_16_2 [1:0],
result_16_1 [1:0],
result_16_0 [1:0] 
};

endmodule

