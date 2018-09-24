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

wire [32:0]   pw_mask       = {
    {16{pw_1                                 }} , 
    { 8{pw_2                          || pw_1}} ,
    { 4{pw_4                  || pw_2 || pw_1}} ,
    { 2{pw_8          || pw_4 || pw_2 || pw_1}} ,
    { 1{pw_16 || pw_8 || pw_4 || pw_2 || pw_1}} ,
    { 1{1'b1                                 }} 
};

wire [ 4:0]   ch_mask       = {
    pw_1                                 , 
    pw_2                          || pw_1,
    pw_4                  || pw_2 || pw_1,
    pw_8          || pw_4 || pw_2 || pw_1,
    pw_16 || pw_8 || pw_4 || pw_2 || pw_1 
};

wire [5:0]   pw_1hot       = {
    pw_1 , 
    pw_2 ,
    pw_4 ,
    pw_8 ,
    pw_16,
    1'b0
};

wire [ 5:0] msk_shamt   = pw_mask & shamt;

wire [31:0] sr_left     = shin << shamt;
wire [31:0] sr_right    = shin >> shamt;

wire [ 4:0] dst_chunks[31:0];
wire [ 4:0] src_chunks[31:0];

genvar i;

generate for(i = 0; i < 32; i = i + 1) begin

    assign dst_chunks[i]   = i & ~(ch_mask);
    assign src_chunks[i]   = (sl||r ? (i-shamt) : (i+shamt)) & ~(ch_mask);
    
    assign c[i] = ((sl || r) ? sr_left[i] : sr_right[i]) &&
        dst_chunks[i] == src_chunks[i];

end endgenerate

endmodule

