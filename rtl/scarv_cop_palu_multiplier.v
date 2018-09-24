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

    output wire [63:0]  add_a   ,   // Adder LHS
    output wire [63:0]  add_b   ,   // Adder RHS
    input  wire [63:0]  add_c   ,   // Adder Result

    output wire [63:0]  result      // Result of the multiplication.

);

`include "scarv_cop_common.vh"

// Pack width decoding
wire   pw_1          = pw == SCARV_COP_PW_1 ; // 1  32-bit word
wire   pw_2          = pw == SCARV_COP_PW_2 ; // 2  16-bit halfwords
wire   pw_4          = pw == SCARV_COP_PW_4 ; // 4   8-bit bytes
wire   pw_8          = pw == SCARV_COP_PW_8 ; // 8   4-bit nibbles
wire   pw_16         = pw == SCARV_COP_PW_16; // 16  2-bit crumbs

// Keep track of the result and what we are adding.
reg [63:0] accumulator;
wire[63:0] toadd        = {32'b0,a & {32{b[ctr & 5'h1F]}}} << ctr;

assign  add_a = {32'b0,toadd};
assign  add_b = ctr == 0 ? 0 : accumulator;

assign result = add_c;

// Counter to keep track of multiplication process.
reg     [5:0] ctr;
wire    [5:0] n_ctr = ctr + 1;
wire    [5:0] ctr_stop;

assign ctr_stop = 
    {6{pw_1 }} & 31 |
    {6{pw_2 }} & 15 |
    {6{pw_4 }} &  7 |
    {6{pw_8 }} &  3 |
    {6{pw_16}} &  1 ;

assign        done  = ctr == ctr_stop && start;

// Updating the accumulator register
always @(posedge g_clk) begin
    if(!g_resetn) begin
        accumulator <= 32'b0;
    end else if(start && ctr == 0) begin
        accumulator <= toadd;
    end else if(start && ctr != 0) begin
        accumulator <= add_c;
    end
end

// Counter updating.
always @(posedge g_clk) begin
    if(!g_resetn) begin
        ctr <= 0;
    end else if(ctr == 0 && !start) begin
        // Do nothing, wait for start
    end else if(ctr == ctr_stop && start) begin
        ctr <= 0;
    end else if(start) begin
        ctr <= n_ctr;
    end
end

endmodule

