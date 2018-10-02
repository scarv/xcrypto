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

input  wire [31:0] id_encoded      , // Encoding 32-bit instruction

output wire        id_exception    , // Illegal instruction exception.

output wire [ 2:0] id_class        , // Instruction class.
output wire [ 3:0] id_subclass     , // Instruction subclass.

output wire [ 2:0] id_pw           , // Instruction pack width.
output wire [ 3:0] id_crs1         , // Instruction source register 1
output wire [ 3:0] id_crs2         , // Instruction source register 2
output wire [ 3:0] id_crs3         , // Instruction source register 3
output wire [ 3:0] id_crd          , // Instruction destination register
output wire [ 3:0] id_crd1         , // MP Instruction destination register 1
output wire [ 3:0] id_crd2         , // MP Instruction destination register 2
output wire [ 4:0] id_rd           , // GPR destination register
output wire [ 4:0] id_rs1          , // GPR source register
output wire [31:0] id_imm          , // Decoded immediate.
output wire        id_wb_h         , // Halfword index (load/store)
output wire        id_wb_b           // Byte index (load/store)

);

//
// Expected to be in same directory as this file.
wire [31:0] encoded = id_encoded;
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

wire   crd_in_crs3 = dec_lmix_cr || dec_hmix_cr || dec_ins_cr ||
                     dec_lli_cr  || dec_lui_cr  || dec_lbu_cr ||
                     dec_lhu_cr  || dec_scatter_b || dec_scatter_h;

assign id_crs3 = crd_in_crs3 ? dec_arg_crd : dec_arg_crs3;

assign id_crd  = dec_arg_crd ;
assign id_rs1  = dec_arg_rs1;
assign id_crd1 = {dec_arg_crdm, 1'b0};
assign id_crd2 = {dec_arg_crdm, 1'b1};
assign id_rd   = dec_arg_rd;
assign id_pw   = {dec_arg_ca, dec_arg_cb, dec_arg_cc};

wire bad_pack_width = 
    (id_pw[2] && |id_pw[1:0]) &&
    id_class == SCARV_COP_ICLASS_PACKED_ARITH;

assign id_exception = 
    dec_invalid_opcode || 
    bad_pack_width      ; // FIXME: Add feature switches to this expression.


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
    dec_lmix_cr || dec_hmix_cr || dec_bop_cr  || dec_ins_cr  || 
    dec_ext_cr  || dec_lli_cr  || dec_lui_cr   ;

assign id_class = 
    {3{class_packed_arith}} & SCARV_COP_ICLASS_PACKED_ARITH |
    {3{class_twiddle     }} & SCARV_COP_ICLASS_TWIDDLE      |
    {3{class_loadstore   }} & SCARV_COP_ICLASS_LOADSTORE    |
    {3{class_random      }} & SCARV_COP_ICLASS_RANDOM       |
    {3{class_move        }} & SCARV_COP_ICLASS_MOVE         |
    {3{class_mp          }} & SCARV_COP_ICLASS_MP           |
    {3{class_bitwise     }} & SCARV_COP_ICLASS_BITWISE      ;


//
// Subclass fields for different instruction classes.
wire [3:0] subclass_load_store = 
    {4{dec_scatter_b}} & {SCARV_COP_SCLASS_SCATTER_B} |
    {4{dec_gather_b }} & {SCARV_COP_SCLASS_GATHER_B } |
    {4{dec_scatter_h}} & {SCARV_COP_SCLASS_SCATTER_H} |
    {4{dec_gather_h }} & {SCARV_COP_SCLASS_GATHER_H } |
    {4{dec_sw_cr    }} & {SCARV_COP_SCLASS_SW_CR    } |
    {4{dec_lw_cr    }} & {SCARV_COP_SCLASS_LW_CR    } |
    {4{dec_sh_cr    }} & {SCARV_COP_SCLASS_SH_CR    } |
    {4{dec_lhu_cr   }} & {SCARV_COP_SCLASS_LH_CR    } |
    {4{dec_sb_cr    }} & {SCARV_COP_SCLASS_SB_CR    } |
    {4{dec_lbu_cr   }} & {SCARV_COP_SCLASS_LB_CR    } ;

wire [3:0] subclass_mp =
    {encoded[19] ? 2'b11 : encoded[11:10], encoded[29:28]};

wire [3:0] subclass_bitwise =
    {4{dec_lmix_cr}} & {SCARV_COP_SCLASS_LMIX_CR} |
    {4{dec_hmix_cr}} & {SCARV_COP_SCLASS_HMIX_CR} |
    {4{dec_bop_cr }} & {SCARV_COP_SCLASS_BOP_CR } |
    {4{dec_ins_cr }} & {SCARV_COP_SCLASS_INS_CR } | 
    {4{dec_ext_cr }} & {SCARV_COP_SCLASS_EXT_CR } |
    {4{dec_lli_cr }} & {SCARV_COP_SCLASS_LLI_CR } |
    {4{dec_lui_cr }} & {SCARV_COP_SCLASS_LUI_CR } ;
    

//
// Identify individual instructions within a class using the subclass
// field.
assign id_subclass = 
    {4{class_packed_arith}} & {encoded[28:25]       } |
    {4{class_twiddle     }} & {1'b0, encoded[23:21] } |
    {4{class_loadstore   }} & {subclass_load_store  } |
    {4{class_random      }} & {encoded[28:25]       } |
    {4{class_move        }} & {encoded[27:24]       } |
    {4{class_mp          }} & {subclass_mp          } |
    {4{class_bitwise     }} & {subclass_bitwise     } ;

//
// Immediate decoding
wire imm_ld     = dec_lw_cr     || dec_lhu_cr   || dec_lbu_cr;
wire imm_st     = dec_sw_cr     || dec_sh_cr    || dec_sb_cr;
wire imm_li     = dec_lui_cr    || dec_lli_cr;
wire imm_8      = class_twiddle || dec_ext_cr   || dec_ins_cr;
wire imm_sh_px  = dec_slli_px   || dec_srli_px  || dec_roti_px;
wire imm_sh_mp  = dec_slli_mp   || dec_srli_mp;
wire imm_lut    = dec_lmix_cr   || dec_hmix_cr  || dec_bop_cr;

assign id_imm = 
    {32{imm_ld      }} & {{21{encoded[31]}}, encoded[31:21]               } |
    {32{imm_st      }} & {{21{encoded[31]}}, encoded[31:25],encoded[10:7] } |
    {32{imm_li      }} & {16'b0, encoded[31:21],encoded[19:15]            } |
    {32{imm_8       }} & {24'b0, encoded[31:24]                           } |
    {32{imm_sh_px   }} & {27'b0, dec_arg_cshamt                           } |
    {32{imm_sh_mp   }} & {27'b0, dec_arg_cmshamt                          } |
    {32{imm_lut     }} & {27'b0, dec_arg_lut4                             } ;

assign id_wb_h = dec_arg_cc ;
assign id_wb_b = imm_ld ? dec_arg_cd : dec_arg_ca;

endmodule
