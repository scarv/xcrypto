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


`VTX_CHECKER_MODULE_BEGIN(instr_aesmix_dec)

wire [7:0] t0 = `CRS1[ 7: 0];
wire [7:0] t1 = `CRS1[15: 8];
wire [7:0] t2 = `CRS2[23:16];
wire [7:0] t3 = `CRS2[31:24];

function [7:0] xt2;
    input[7:0] a;
    xt2 = a[7] ? (a << 1) ^ 8'h1b : (a<<1);
endfunction

function [7:0] xtX;
    input[7:0] a;
    input[3:0] b;
    xtX = 
        (b[0] ?             a   : 0) ^
        (b[1] ? xt2(        a)  : 0) ^
        (b[2] ? xt2(xt2(    a)) : 0) ^
        (b[3] ? xt2(xt2(xt2(a))): 0) ;
endfunction

reg [7:0] exp0;
reg [7:0] exp1;
reg [7:0] exp2;
reg [7:0] exp3;

wire [31:0] mixdec_expected = {exp3,exp2,exp1,exp0};

always @(*) begin
    exp3 = xtX(t0,4'hb) ^ xtX(t1,4'hd) ^ xtX(t2,4'h9) ^ xtX(t3,4'he) ;
    exp2 = xtX(t0,4'hd) ^ xtX(t1,4'h9) ^ xtX(t2,4'he) ^ xtX(t3,4'hb) ;
    exp1 = xtX(t0,4'h9) ^ xtX(t1,4'he) ^ xtX(t2,4'hb) ^ xtX(t3,4'hd) ;
    exp0 = xtX(t0,4'he) ^ xtX(t1,4'hb) ^ xtX(t2,4'hd) ^ xtX(t3,4'h9) ;
end

//
// aes_mix_dec
//
`VTX_CHECK_INSTR_BEGIN(aesmix_dec) 
    
    // Value of destination register post instruction should be the same
    // as the most recent 32-bit random sample.
    `VTX_ASSERT_CRD_VALUE_IS(mixdec_expected);
    
    // Always succeeds
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    // Never writes to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR
    
`VTX_CHECK_INSTR_END(aesmix_dec)

`VTX_CHECKER_MODULE_END(instr_aesmix_dec)


