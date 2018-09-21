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
// module scarv_cop_palu_multiplier
//
//  Logic for a shift and add multiplier, which re-uses an external
//  packed adder.
//
module scarv_cop_palu_multiplier (
    input  wire         g_clk   ,   // Global clock.
    input  wire         g_resetn,   // Global synchronous active low reset

    input  wire         start   ,   // Trigger to start multiplying
    output wire         done    ,   // Signal multiplication has finished.

    input  wire [31:0]  a       ,   // LHS operand
    input  wire [31:0]  b       ,   // RHS operand
    input  wire [ 2:0]  pw      ,   // Pack width.

    output wire [63:0]  result      // Result of the multiplication.

);

`include "scarv_cop_common.vh"

// Pack width decoding
wire   pw_1          = pw == SCARV_COP_PW_1 ; // 1  32-bit word
wire   pw_2          = pw == SCARV_COP_PW_2 ; // 2  16-bit halfwords
wire   pw_4          = pw == SCARV_COP_PW_4 ; // 4   8-bit bytes
wire   pw_8          = pw == SCARV_COP_PW_8 ; // 8   4-bit nibbles
wire   pw_16         = pw == SCARV_COP_PW_16; // 16  2-bit crumbs
wire   pw_1hot       = {
    pw_1 , 
    pw_2 ,
    pw_4 ,
    pw_8 ,
    pw_16,
    1'b0  
};

// Keep track of the result and what we are adding.
reg [63:0] toadd;
reg [63:0] accumulator;

assign adder_pw = pw;
assign adder_a  = accumulator[31:0];
assign adder_b  = a & {32{b[ctr[4:0]]}};

// Counter to keep track of multiplication process.
reg     [5:0] ctr;
wire    [5:0] n_ctr = ctr - 1;

assign        done  = ctr == 0 && start;

// Counter updating.
always @(posedge g_clk) begin
    if(!g_resetn) begin
        ctr <= 0;
    end else if(ctr == 6'b10000 && start) begin
        if(pw_1 ) ctr <= 31;
        if(pw_2 ) ctr <= 15;
        if(pw_4 ) ctr <=  7;
        if(pw_8 ) ctr <=  3;
        if(pw_16) ctr <=  1;
    end else if(ctr == 0) begin
        ctr <= 6'b100000;
    end else if(ctr != 0) begin
        ctr <= n_ctr;
    end
end

endmodule

