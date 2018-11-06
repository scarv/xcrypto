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
    input  wire         high    ,   // Return high/low 32-bits of results.
    input  wire         ncarry  ,   // If set, do carryless multiplication

    output reg  [31:0]  result      // Result of the multiplication.

);

`include "scarv_cop_common.vh"

// Pack width decoding
wire   pw_1          = pw == SCARV_COP_PW_1 ; // 1  32-bit word
wire   pw_2          = pw == SCARV_COP_PW_2 ; // 2  16-bit halfwords
wire   pw_4          = pw == SCARV_COP_PW_4 ; // 4   8-bit bytes
wire   pw_8          = pw == SCARV_COP_PW_8 ; // 8   4-bit nibbles
wire   pw_16         = pw == SCARV_COP_PW_16; // 16  2-bit crumbs

// Counter to keep track of multiplication process.
reg     [5:0] ctr;
wire    [5:0] n_ctr = ctr + 1;
wire    [5:0] ctr_stop;


// Keep track of the result and what we are adding.
reg  [63:0] accumulator  ;
reg  [63:0] n_accumulator;

// --------------------------------------------------------------------

wire [31:0] bshf = b >> ctr;

`define NACC(A,B,C,D,E,F,G) \
    n_accumulator[A :B ] = \
        ncarry ? ((ctr == 0) ? 0 :accumulator[A :B ]) ^ (bshf[  C] ? ({  D  ,a[E : F]} << ctr) : G) : \
                 ((ctr == 0) ? 0 :accumulator[A :B ]) + (bshf[  C] ? ({  D  ,a[E : F]} << ctr) : G) ; \
    result       [E :F ] = high ?  n_accumulator[A:B+((A-B)/2)+1] : n_accumulator[B+((A-B)/2)  :B]

always @(*) case(pw)
SCARV_COP_PW_1: begin
    `NACC(63,  0,  0, 32'b0, 31,  0, 64'b0);
end
SCARV_COP_PW_2: begin
    `NACC(63, 32, 16, 16'b0, 31, 16, 32'b0);
    `NACC(31,  0,  0, 16'b0, 15,  0, 32'b0);
end
SCARV_COP_PW_4: begin
    `NACC(63, 48, 24,  8'b0, 31, 24, 16'b0);
    `NACC(47, 32, 16,  8'b0, 23, 16, 16'b0);
    `NACC(31, 16,  8,  8'b0, 15,  8, 16'b0);
    `NACC(15,  0,  0,  8'b0,  7,  0, 16'b0);
end
SCARV_COP_PW_8: begin
    `NACC(63, 56, 28,  4'b0, 31, 28,  8'b0);
    `NACC(55, 48, 24,  4'b0, 27, 24,  8'b0);
    `NACC(47, 40, 20,  4'b0, 23, 20,  8'b0);
    `NACC(39, 32, 16,  4'b0, 19, 16,  8'b0);
    `NACC(31, 24, 12,  4'b0, 15, 12,  8'b0);
    `NACC(23, 16,  8,  4'b0, 11,  8,  8'b0);
    `NACC(15,  8,  4,  4'b0,  7,  4,  8'b0);
    `NACC( 7,  0,  0,  4'b0,  3,  0,  8'b0);
end
SCARV_COP_PW_16: begin
    `NACC(63, 60, 30,  2'b0, 31, 30,  4'b0);
    `NACC(59, 56, 28,  2'b0, 29, 28,  4'b0);
    `NACC(55, 52, 26,  2'b0, 27, 26,  4'b0);
    `NACC(51, 48, 24,  2'b0, 25, 24,  4'b0);
    `NACC(47, 44, 22,  2'b0, 23, 22,  4'b0);
    `NACC(43, 40, 20,  2'b0, 21, 20,  4'b0);
    `NACC(39, 36, 18,  2'b0, 19, 18,  4'b0);
    `NACC(35, 32, 16,  2'b0, 17, 16,  4'b0);
    `NACC(31, 28, 14,  2'b0, 15, 14,  4'b0);
    `NACC(27, 24, 12,  2'b0, 13, 12,  4'b0);
    `NACC(23, 20, 10,  2'b0, 11, 10,  4'b0);
    `NACC(19, 16,  8,  2'b0,  9,  8,  4'b0);
    `NACC(15, 12,  6,  2'b0,  7,  6,  4'b0);
    `NACC(11,  8,  4,  2'b0,  5,  4,  4'b0);
    `NACC( 7,  4,  2,  2'b0,  3,  2,  4'b0);
    `NACC( 3,  0,  0,  2'b0,  1,  0,  4'b0);
end
default: begin
    n_accumulator = 0;
    result = 0;
end
endcase

// --------------------------------------------------------------------

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
        accumulator <= n_accumulator;
    end else if(start && ctr != 0) begin
        accumulator <= n_accumulator;
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

