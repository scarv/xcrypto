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


`VTX_CHECKER_MODULE_BEGIN(instr_aesmix_enc)

wire [7:0] t0 = `CRS1[ 7: 0];
wire [7:0] t1 = `CRS2[15: 8];
wire [7:0] t2 = `CRS1[23:16];
wire [7:0] t3 = `CRS2[31:24];

function [7:0] xt2;
    input[7:0] a;
    xt2 = a[7] ? (a << 1) ^ 8'h1b : (a<<1);
endfunction

function [7:0] xt3;
    input[7:0] a;
    xt3 = a ^ xt2(a);
endfunction

reg [7:0] exp0;
reg [7:0] exp1;
reg [7:0] exp2;
reg [7:0] exp3;

wire [31:0] mixenc_expected = {exp3,exp2,exp1,exp0};

always @(*) begin
    exp3 = xt2(t0) ^ xt3(t1) ^     t2  ^     t3  ;
    exp2 =     t0  ^ xt2(t1) ^ xt3(t2) ^     t3  ;
    exp1 =     t0  ^     t1  ^ xt2(t2) ^ xt3(t3) ;
    exp0 = xt3(t0) ^     t1  ^     t2  ^ xt2(t3) ;
end

//
// aes_mix_enc
//
`VTX_CHECK_INSTR_BEGIN(aesmix_enc) 
    
    // Value of destination register post instruction should be the same
    // as the most recent 32-bit random sample.
    `VTX_ASSERT_CRD_VALUE_IS(mixenc_expected);
    
    // Always succeeds
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    // Never writes to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR
    
`VTX_CHECK_INSTR_END(aesmix_enc)

`VTX_CHECKER_MODULE_END(instr_aesmix_enc)

