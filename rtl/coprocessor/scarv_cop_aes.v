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
    sub_instr ||
    ((mix_enc || mix_dec) && mix_fsm_3);

assign aes_cpr_rd_ben   = 
    {4{sub_instr}} |
    ({3'b0,mix_instr} << mix_fsm);

assign aes_cpr_rd_wdata = 
    {32{sub_instr}} & sbox_output   |
    {24'b0, {8{mix_instr}} & mix_output} << {mix_fsm,3'b0};

//
// Mix columns state machine.
reg  [1:0] mix_fsm;
wire [1:0] n_mix_fsm = mix_fsm + 1;

wire       mix_fsm_0 = mix_fsm == 2'd0 && mix_instr;
wire       mix_fsm_1 = mix_fsm == 2'd1 && mix_instr;
wire       mix_fsm_2 = mix_fsm == 2'd2 && mix_instr;
wire       mix_fsm_3 = mix_fsm == 2'd3 && mix_instr;

always @(posedge g_clk) begin
    if(!g_resetn) begin
        mix_fsm <= 2'b00;
    end else if(mix_enc || mix_dec) begin
        mix_fsm <= n_mix_fsm;
    end
end

//
// multiplication function for two 8 bit numbers
function [7:0] xmul;
    input [7:0] lhs;
    input [7:0] rhs;
    
    xmul = 
        ({8{rhs[0]}} & (lhs << 0)) ^
        ({8{rhs[1]}} & (lhs << 1)) ^
        ({8{rhs[2]}} & (lhs << 2)) ^
        ({8{rhs[3]}} & (lhs << 3)) ^
        ({8{rhs[4]}} & (lhs << 4)) ^
        ({8{rhs[5]}} & (lhs << 5)) ^
        ({8{rhs[6]}} & (lhs << 6)) ^
        ({8{rhs[7]}} & (lhs << 7)) ;
endfunction

//
// MIX instruction logic
wire [7:0] t0 = aes_rs1[ 7: 0];
wire [7:0] t1 = aes_rs2[15: 8];
wire [7:0] t2 = aes_rs1[23:16];
wire [7:0] t3 = aes_rs2[31:24];

wire [7:0] mix_output_enc =
  {7{mix_fsm_0}} & (xmul( 2,t0) ^ xmul( 3,t1) ^ xmul( 1,t2) ^ xmul( 1,t3)) |
  {7{mix_fsm_1}} & (xmul( 1,t0) ^ xmul( 2,t1) ^ xmul( 3,t2) ^ xmul( 1,t3)) |
  {7{mix_fsm_2}} & (xmul( 1,t0) ^ xmul( 1,t1) ^ xmul( 2,t2) ^ xmul( 3,t3)) |
  {7{mix_fsm_3}} & (xmul( 3,t0) ^ xmul( 1,t1) ^ xmul( 1,t2) ^ xmul( 2,t3)) ;

wire [7:0] mix_output_dec =
  {7{mix_fsm_0}} & (xmul(14,t0) ^ xmul(11,t1) ^ xmul(13,t2) ^ xmul( 9,t3)) |
  {7{mix_fsm_1}} & (xmul( 9,t0) ^ xmul(14,t1) ^ xmul(11,t2) ^ xmul(13,t3)) |
  {7{mix_fsm_2}} & (xmul(13,t0) ^ xmul( 9,t1) ^ xmul(14,t2) ^ xmul(11,t3)) |
  {7{mix_fsm_3}} & (xmul(11,t0) ^ xmul(13,t1) ^ xmul( 9,t2) ^ xmul(14,t3)) ;

wire [7:0] mix_output = mode_enc ? mix_output_enc : mix_output_dec;

//
// SBOX signal input/output
wire [ 7:0] sbox_input_0    = {8{sub_instr}} & aes_rs1[ 7: 0];
wire [ 7:0] sbox_input_1    = {8{sub_instr}} & aes_rs2[15: 8];
wire [ 7:0] sbox_input_2    = {8{sub_instr}} & aes_rs1[23:16];
wire [ 7:0] sbox_input_3    = {8{sub_instr}} & aes_rs2[31:24];

wire        sbox_invert     = !mode_enc;

wire [ 7:0] sbox_output_0;
wire [ 7:0] sbox_output_1;
wire [ 7:0] sbox_output_2;
wire [ 7:0] sbox_output_3;

wire [31:0] sbox_output = rotate ? 
    {sbox_output_2, sbox_output_1, sbox_output_0, sbox_output_3} :
    {sbox_output_3, sbox_output_2, sbox_output_1, sbox_output_0} ;

//
// SBOX Instances

scarv_cop_aes_sbox i_sbox_0 (
.in (sbox_input_0    ),
.inv(sbox_invert     ),
.out(sbox_output_0   ) 
);

scarv_cop_aes_sbox i_sbox_1 (
.in (sbox_input_1    ),
.inv(sbox_invert     ),
.out(sbox_output_1   ) 
);

scarv_cop_aes_sbox i_sbox_2 (
.in (sbox_input_2    ),
.inv(sbox_invert     ),
.out(sbox_output_2   ) 
);

scarv_cop_aes_sbox i_sbox_3 (
.in (sbox_input_3    ),
.inv(sbox_invert     ),
.out(sbox_output_3   ) 
);

endmodule
