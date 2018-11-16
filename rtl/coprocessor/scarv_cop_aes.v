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
// module: scarv_cop_aes
//
//  Implements the AES instruction functionality for the co-processor
//
module scarv_cop_aes (
input  wire         g_clk           ,
input  wire         g_resetn        ,

input  wire         aes_ivalid      , // Valid instruction input
output wire         aes_idone       , // Instruction complete

input  wire [31:0]  aes_rs1         , // Source register 1
input  wire [31:0]  aes_rs2         , // Source register 2
input  wire [31:0]  aes_rs3         , // Source register 3

input  wire [31:0]  id_imm          , // Source immedate
input  wire [ 2:0]  id_pw           , // Pack width
input  wire [ 3:0]  id_class        , // Instruction class
input  wire [ 4:0]  id_subclass     , // Instruction subclass

output wire [ 3:0]  aes_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  aes_cpr_rd_wdata  // Writeback data
);

// Commom field name and values.
`include "scarv_cop_common.vh"

//
// Individual instruction signals
wire sub_enc    = aes_ivalid && id_subclass == SCARV_COP_SCLASS_AESSUB_ENC;
wire sub_encrot = aes_ivalid && id_subclass == SCARV_COP_SCLASS_AESSUB_ENCROT;
wire sub_dec    = aes_ivalid && id_subclass == SCARV_COP_SCLASS_AESSUB_DEC;
wire sub_decrot = aes_ivalid && id_subclass == SCARV_COP_SCLASS_AESSUB_DECROT;
wire mix_enc    = aes_ivalid && id_subclass == SCARV_COP_SCLASS_AESMIX_ENC;
wire mix_dec    = aes_ivalid && id_subclass == SCARV_COP_SCLASS_AESMIX_DEC;

wire mix_instr  = mix_enc || mix_dec;
wire sub_instr  = sub_enc || sub_encrot || sub_dec || sub_decrot;
wire mode_enc   = sub_enc || sub_encrot || mix_enc;
wire rotate     = sub_encrot || sub_decrot;

assign aes_idone        = 
    (sub_instr            && aes_fsm_3) ||
    ((mix_enc || mix_dec) && aes_fsm_3);

assign aes_cpr_rd_ben   = 
    sub_ben_rot                   |
    ({3'b0,mix_instr} << aes_fsm);

assign aes_cpr_rd_wdata = 
    {32{sub_instr}} & sbox_output   |
    {24'b0, {8{mix_instr}} & mix_output} << {aes_fsm,3'b0};

//
// Mix columns state machine.
reg  [1:0] aes_fsm;
wire [1:0] n_aes_fsm = aes_fsm + 1;

wire       aes_fsm_0 = aes_fsm == 2'd0;
wire       aes_fsm_1 = aes_fsm == 2'd1;
wire       aes_fsm_2 = aes_fsm == 2'd2;
wire       aes_fsm_3 = aes_fsm == 2'd3;

always @(posedge g_clk) begin
    if(!g_resetn) begin
        aes_fsm <= 2'b00;
    end else if(mix_instr || sub_instr) begin
        aes_fsm <= n_aes_fsm;
    end
end

//
// Multiply by 2 in GF(2^8) modulo 8'h1b
//
function [7:0] xtime2;
    input [7:0] a;

    xtime2 = ((a >> 7) & 1'b1) ? (a << 1) ^ 8'h1b :
                                (a << 1)         ;
endfunction

//
// Multiply by 3 in GF(2^8)
//
function [7:0] xtime3;
    input [7:0] a;

    xtime3 = xtime2(a) ^ a;

endfunction

//
// Paired down multiply by X in GF(2^8)
//
function [7:0] xtimeN;
    input[7:0] a;
    input[3:0] b;

    xtimeN = 
        (b[0] ?                         a   : 0) ^
        (b[1] ? xtime2(                 a)  : 0) ^
        (b[2] ? xtime2(xtime2(          a)) : 0) ^
        (b[3] ? xtime2(xtime2(xtime2(   a))): 0) ;

endfunction


//
// MIX instruction logic
wire [7:0] t0 = aes_rs1[ 7: 0] & {8{mix_instr}};
wire [7:0] t1 = aes_rs2[15: 8] & {8{mix_instr}};
wire [7:0] t2 = aes_rs1[23:16] & {8{mix_instr}};
wire [7:0] t3 = aes_rs2[31:24] & {8{mix_instr}};

reg  [7:0] mix_output_enc;
reg  [7:0] mix_output_dec;

always @(*) begin : p_compute_mix_output_enc
    case(aes_fsm)
        2'b00: mix_output_enc = xtime2(t0) ^ xtime3(t1) ^ t2 ^ t3;
        2'b01: mix_output_enc = xtime2(t1) ^ xtime3(t2) ^ t0 ^ t3;
        2'b10: mix_output_enc = xtime2(t2) ^ xtime3(t3) ^ t0 ^ t1;
        2'b11: mix_output_enc = xtime2(t3) ^ xtime3(t0) ^ t1 ^ t2;
    endcase
end

always @(*) begin : p_compute_mix_output_dec
    case(aes_fsm)
        2'b00: mix_output_dec = 
            xtimeN(t0,8'he)^xtimeN(t1,8'hb)^xtimeN(t2,8'hd)^xtimeN(t3,8'h9);
        2'b01: mix_output_dec =
            xtimeN(t0,8'h9)^xtimeN(t1,8'he)^xtimeN(t2,8'hb)^xtimeN(t3,8'hd);
        2'b10: mix_output_dec =
            xtimeN(t0,8'hd)^xtimeN(t1,8'h9)^xtimeN(t2,8'he)^xtimeN(t3,8'hb);
        2'b11: mix_output_dec =
            xtimeN(t0,8'hb)^xtimeN(t1,8'hd)^xtimeN(t2,8'h9)^xtimeN(t3,8'he);
    endcase
end

wire [7:0] mix_output = mode_enc ? mix_output_enc : mix_output_dec;

//
// SBOX signal input/output
wire [ 7:0] sbox_input_0    = 
    {8{sub_instr && aes_fsm_0}} & aes_rs1[ 7: 0]|
    {8{sub_instr && aes_fsm_1}} & aes_rs2[15: 8]|
    {8{sub_instr && aes_fsm_2}} & aes_rs1[23:16]|
    {8{sub_instr && aes_fsm_3}} & aes_rs2[31:24];

wire        sbox_invert     = !mode_enc;

wire [ 7:0] sbox_output_0;

wire [31:0] sbox_output = {sbox_output_0,sbox_output_0,
                           sbox_output_0,sbox_output_0};

wire [3:0] sub_ben      = {3'b0, sub_instr} << aes_fsm;
wire [3:0] sub_ben_rot  = rotate ? {sub_ben[2:0],sub_ben[3]} :
                                    sub_ben                  ;

//
// SBOX Instances

scarv_cop_aes_sbox i_sbox_0 (
.in (sbox_input_0    ),
.inv(sbox_invert     ),
.out(sbox_output_0   ) 
);

endmodule
