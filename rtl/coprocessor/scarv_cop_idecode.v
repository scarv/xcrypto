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

output wire [ 3:0] id_class        , // Instruction class.
output wire [ 4:0] id_subclass     , // Instruction subclass.

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
//  This file is expected to be found in the $XC_WORK directory.
//
`include "ise_decode.v"

assign id_crs1 = dec_arg_crs1;
assign id_crs2 = dec_arg_crs2;

wire   crd_in_crs3 = dec_mix_l || dec_mix_h || dec_ins ||
                     dec_ld_liu  || dec_ld_hiu  || dec_ld_bu ||
                     dec_ld_hu  || dec_scatter_b || dec_scatter_h;

assign id_crs3 = crd_in_crs3 ? dec_arg_crd : dec_arg_crs3;

assign id_crd  = dec_arg_crd ;
assign id_rs1  = dec_arg_rs1;
assign id_crd1 = {dec_arg_crdm, 1'b0};
assign id_crd2 = {dec_arg_crdm, 1'b1};
assign id_rd   = dec_arg_rd;
assign id_pw   = {dec_arg_ca, dec_arg_cb, dec_arg_cc};

wire shift_imm_pack_width =
        id_pw == 3'b100 &&
        (dec_psll_i || dec_psrl_i || dec_prot_i);

wire bad_pack_width = 
    !shift_imm_pack_width            &&
    id_pw != SCARV_COP_PW_1          &&
    id_pw != SCARV_COP_PW_2          &&
    id_pw != SCARV_COP_PW_4          &&
    id_pw != SCARV_COP_PW_8          &&
    id_pw != SCARV_COP_PW_16         &&
    id_class == SCARV_COP_ICLASS_PACKED_ARITH;

assign id_exception = 
    dec_invalid_opcode || 
    bad_pack_width      ; // FIXME: Add feature switches to this expression.


//
// Which class of instruction have we decoded?
wire class_packed_arith = 
    dec_padd  || dec_psub  || dec_pmul_l || dec_psll   || 
    dec_psrl  || dec_prot  || dec_psll_i || dec_psrl_i || 
    dec_prot_i|| dec_pmul_h|| dec_pclmul_l|| dec_pclmul_h;

wire class_twiddle      = 
    dec_pperm_w  || dec_pperm_h0 || dec_pperm_h1 || dec_pperm_b0 ||
    dec_pperm_b1 || dec_pperm_b2 || dec_pperm_b3  ;

wire class_loadstore    = 
    dec_scatter_b || dec_gather_b  || dec_scatter_h || dec_gather_h  ||
    dec_ld_bu    || dec_ld_hu    || dec_ld_w     || dec_st_b     ||
    dec_st_h     || dec_st_w     ;

wire class_random       = 
    dec_rngseed || dec_rngsamp || dec_rngtest;

wire class_move         = 
    dec_xcr2gpr   || dec_gpr2xcr   || dec_cmov_t ||  dec_cmov_f ;

wire class_mp           = 
    dec_mequ   || dec_mlte   || dec_mgte     || dec_madd_3 || 
    dec_madd_2 || dec_msub_3 || dec_msub_2   || dec_msll_i || 
    dec_msll   || dec_msrl_i || dec_msrl     || dec_macc_2 || 
    dec_macc_1 || dec_mmul_3 || dec_mclmul_3  ;

wire class_bitwise      = 
    dec_mix_l || dec_mix_h  || dec_bop    || dec_ins    || 
    dec_ext   || dec_ld_liu || dec_ld_hiu || dec_lut  ;

wire class_aes          =
    dec_aessub_enc || dec_aessub_encrot || dec_aessub_dec || 
    dec_aessub_decrot || dec_aesmix_enc || dec_aesmix_dec;

wire class_sha3         =
    dec_sha3_xy || dec_sha3_x1 || dec_sha3_x2 || dec_sha3_x4 || dec_sha3_yx;

assign id_class = 
    {4{class_sha3        }} & SCARV_COP_ICLASS_SHA3         |
    {4{class_aes         }} & SCARV_COP_ICLASS_AES          |
    {4{class_packed_arith}} & SCARV_COP_ICLASS_PACKED_ARITH |
    {4{class_twiddle     }} & SCARV_COP_ICLASS_TWIDDLE      |
    {4{class_loadstore   }} & SCARV_COP_ICLASS_LOADSTORE    |
    {4{class_random      }} & SCARV_COP_ICLASS_RANDOM       |
    {4{class_move        }} & SCARV_COP_ICLASS_MOVE         |
    {4{class_mp          }} & SCARV_COP_ICLASS_MP           |
    {4{class_bitwise     }} & SCARV_COP_ICLASS_BITWISE      ;


//
// Subclass fields for different instruction classes.
wire [4:0] subclass_load_store = 
    {5{dec_scatter_b}} & {SCARV_COP_SCLASS_SCATTER_B} |
    {5{dec_gather_b }} & {SCARV_COP_SCLASS_GATHER_B } |
    {5{dec_scatter_h}} & {SCARV_COP_SCLASS_SCATTER_H} |
    {5{dec_gather_h }} & {SCARV_COP_SCLASS_GATHER_H } |
    {5{dec_st_w    }} & {SCARV_COP_SCLASS_ST_W    } |
    {5{dec_ld_w    }} & {SCARV_COP_SCLASS_LD_W    } |
    {5{dec_st_h    }} & {SCARV_COP_SCLASS_ST_H    } |
    {5{dec_ld_hu   }} & {SCARV_COP_SCLASS_LH_CR    } |
    {5{dec_st_b    }} & {SCARV_COP_SCLASS_ST_B    } |
    {5{dec_ld_bu   }} & {SCARV_COP_SCLASS_LB_CR    } ;

wire [4:0] subclass_mp =
    {5{dec_mequ }} & {SCARV_COP_SCLASS_MEQU  } | 
    {5{dec_mlte }} & {SCARV_COP_SCLASS_MLTE  } | 
    {5{dec_mgte }} & {SCARV_COP_SCLASS_MGTE  } | 
    {5{dec_madd_3}} & {SCARV_COP_SCLASS_MADD_3 } | 
    {5{dec_madd_2}} & {SCARV_COP_SCLASS_MADD_2 } | 
    {5{dec_msub_3}} & {SCARV_COP_SCLASS_MSUB_3 } | 
    {5{dec_msub_2}} & {SCARV_COP_SCLASS_MSUB_2 } | 
    {5{dec_msll_i}} & {SCARV_COP_SCLASS_MSLL_I } | 
    {5{dec_msll }} & {SCARV_COP_SCLASS_MSLL  } | 
    {5{dec_msrl_i}} & {SCARV_COP_SCLASS_MSRL_I } | 
    {5{dec_msrl }} & {SCARV_COP_SCLASS_MSRL  } | 
    {5{dec_macc_2}} & {SCARV_COP_SCLASS_MACC_2 } | 
    {5{dec_macc_1}} & {SCARV_COP_SCLASS_MACC_1 } | 
    {5{dec_mmul_3 }} & {SCARV_COP_SCLASS_MMUL_3  } |
    {5{dec_mclmul_3}} & {SCARV_COP_SCLASS_MCLMUL_3  } ;

wire [4:0] subclass_bitwise =
    {5{dec_mix_l}} & {SCARV_COP_SCLASS_MIX_L} |
    {5{dec_mix_h}} & {SCARV_COP_SCLASS_MIX_H} |
    {5{dec_bop }} & {SCARV_COP_SCLASS_BOP } |
    {5{dec_ins }} & {SCARV_COP_SCLASS_INS } | 
    {5{dec_ext }} & {SCARV_COP_SCLASS_EXT } |
    {5{dec_ld_liu }} & {SCARV_COP_SCLASS_LD_LIU } |
    {5{dec_ld_hiu }} & {SCARV_COP_SCLASS_LD_HIU } |
    {5{dec_lut}} & {SCARV_COP_SCLASS_LUT} ;
    
wire [4:0] subclass_aes = 
    {5{dec_aessub_enc   }} & SCARV_COP_SCLASS_AESSUB_ENC    |
    {5{dec_aessub_encrot}} & SCARV_COP_SCLASS_AESSUB_ENCROT |
    {5{dec_aessub_dec   }} & SCARV_COP_SCLASS_AESSUB_DEC    |
    {5{dec_aessub_decrot}} & SCARV_COP_SCLASS_AESSUB_DECROT |
    {5{dec_aesmix_enc   }} & SCARV_COP_SCLASS_AESMIX_ENC    |
    {5{dec_aesmix_dec   }} & SCARV_COP_SCLASS_AESMIX_DEC    ;

wire [4:0] subclass_sha3 = encoded[29:25];

//
// Identify individual instructions within a class using the subclass
// field.
assign id_subclass = 
    {5{class_sha3        }} & {subclass_sha3        } |
    {5{class_aes         }} & {subclass_aes         } |
    {5{class_packed_arith}} & {encoded[29:25]       } |
    {5{class_twiddle     }} & {1'b0, encoded[23:21] } |
    {5{class_loadstore   }} & {subclass_load_store  } |
    {5{class_random      }} & {encoded[24:20]       } |
    {5{class_move        }} & {encoded[28:24]       } |
    {5{class_mp          }} & {subclass_mp          } |
    {5{class_bitwise     }} & {subclass_bitwise     } ;

//
// Immediate decoding
wire imm_ld     = dec_ld_w     || dec_ld_hu   || dec_ld_bu;
wire imm_st     = dec_st_w     || dec_st_h    || dec_st_b;
wire imm_li     = dec_ld_hiu   || dec_ld_liu;
wire imm_8      = class_twiddle || dec_ext   || dec_ins || class_sha3;
wire imm_sh_px  = dec_psll_i   || dec_psrl_i  || dec_prot_i;
wire imm_sh_mp  = dec_msll_i   || dec_msrl_i;
wire imm_lut    = dec_bop;
wire imm_rtamt  = dec_mix_l   || dec_mix_h  || dec_bop;

wire [4:0] shamt_imm =
    {dec_arg_cb, dec_arg_cc} == 2'b00 ? {dec_arg_ca, dec_arg_cshamt} :
                                        {1'b0      , dec_arg_cshamt} ;

assign id_imm = 
    {32{imm_ld      }} & {{21{encoded[31]}}, encoded[31:21]               } |
    {32{imm_st      }} & {{21{encoded[31]}}, encoded[31:25],encoded[10:7] } |
    {32{imm_li      }} & {16'b0, encoded[31:21],encoded[19:15]            } |
    {32{imm_8       }} & {24'b0, encoded[31:24]                           } |
    {32{imm_sh_px   }} & {27'b0, shamt_imm                                } |
    {32{imm_sh_mp   }} & {26'b0, dec_arg_cmshamt                          } |
    {32{imm_lut     }} & {28'b0, dec_arg_lut4                             } |
    {32{imm_rtamt   }} & {28'b0, dec_arg_rtamt                            } ;

assign id_wb_h = dec_arg_cc ;
assign id_wb_b = imm_ld ? dec_arg_cd : dec_arg_ca;

endmodule
