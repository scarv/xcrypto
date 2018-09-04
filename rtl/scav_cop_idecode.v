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
// module: scarv_cop_idecode
//
//  A fully combinatorial instruction decoder for the ISE.
//
module scarv_cop_idecode (

input  [31:0]   id_encoded      , // Encoding 32-bit instruction

output          id_exception    , // Illegal instruction exception.

output [ 2:0]   id_class        . // Instruction class.
output [ 3:0]   id_subclass     , // Instruction subclass.

output [ 2:0]   id_pw           , // Instruction pack width.
output [ 3:0]   id_crs1         , // Instruction source register 1
output [ 3:0]   id_crs2         , // Instruction source register 2
output [ 3:0]   id_crs3         , // Instruction source register 3
output [ 3:0]   id_crd1         , // Instruction destination register 1
output [ 3:0]   id_crd2         , // Instruction destination register 2
output [ 4:0]   id_rd           , // GPR destination register
output [ 4:0]   id_rs1          , // GPR source register
output [31:0]   id_imm            // Decoded immediate.

);

//
// Expected to be in same directory as this file.
`include "scarv_cop_common.vh"

parameter ISE_MCCR_R    = 1; // Feature enable bits.
parameter ISE_MCCR_MP   = 1; // 
parameter ISE_MCCR_SG   = 1; // 
parameter ISE_MCCR_P32  = 1; // 
parameter ISE_MCCR_P16  = 1; // 
parameter ISE_MCCR_P8   = 1; // 
parameter ISE_MCCR_P4   = 1; // 
parameter ISE_MCCR_P2   = 1; // 

//
// Include the generated decoder. Exposes two classes of signal:
//  - dec_* for each instruction
//  - dec_arg_* for each possible instruction argument field.
//
//  This file is expected to be found in the $COP_WORK directory.
//
`include "ise_decode.v"

assign id_crs1 = dec_arg_crs1;
assign id_crs2 = dec_arg_crs2;
assign id_crs3 = dec_arg_crs3;
assign id_rs1  = dec_arg_rs1;
assign id_crd1 = {dec_arg_crdm, 2'b00};
assign id_crd2 = {dec_arg_crdm, 2'b01};
assign id_rd   = dec_arg_rd;
assign id_pw   = {dec_arg_ca, dec_arg_cb, dec_arg_cc};

assign id_exception = 
    dec_invalid_opcode; // FIXME: Add feature switches to this expression.


//
// Which class of instruction have we decoded?
wire class_packed_arith = 
    dec_add_px  || dec_sub_px  || dec_mul_px  || dec_sll_px  || 
    dec_srl_px  || dec_rot_px  || dec_slli_px || dec_srli_px || dec_roti_px ;

wire class_twiddle      = 
    dec_twid_b  || dec_twid_n0 || dec_twid_n1 || dec_twid_c0 ||
    dec_twid_c1 || dec_twid_c2 || dec_twid_c3  ;

wire class_loadstore    = 
    dec_scatter_b || dec_gather_b  || dec_scatter_h || dec_gather_h  ||
    dec_lbu_cr    || dec_lhu_cr    || dec_lw_cr     || dec_sb_cr     ||
    dec_sh_cr     || dec_sw_cr     ;

wire class_random       = 
    dec_rseed_cr || dec_rsamp_cr;

wire class_move         = 
    dec_mv2gpr   || dec_mv2cop   || dec_cmov_cr ||  dec_cmovn_cr ;

wire class_mp           = 
    dec_equ_mp  || dec_ltu_mp  || dec_gtu_mp  || dec_add3_mp || 
    dec_add2_mp || dec_sub3_mp || dec_sub2_mp || dec_slli_mp || 
    dec_sll_mp  || dec_srli_mp || dec_srl_mp  || dec_acc2_mp || 
    dec_acc1_mp || dec_mac_mp   ;

wire class_bitwise      = 
    dec_lmix_cr || dec_hmix_cr || dec_bop_cr  || dec_ins_cr  || dec_ext_cr;


endmodule
