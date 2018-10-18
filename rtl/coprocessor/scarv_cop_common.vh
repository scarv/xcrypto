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

localparam SCARV_COP_INSN_SUCCESS =  3'b000;
localparam SCARV_COP_INSN_ABORT   =  3'b001;
localparam SCARV_COP_INSN_BAD_INS =  3'b010;
localparam SCARV_COP_INSN_BAD_LAD =  3'b100;
localparam SCARV_COP_INSN_BAD_SAD =  3'b101;
localparam SCARV_COP_INSN_LD_ERR  =  3'b110;
localparam SCARV_COP_INSN_ST_ERR  =  3'b111;

localparam SCARV_COP_ICLASS_PACKED_ARITH = 3'b001;
localparam SCARV_COP_ICLASS_TWIDDLE      = 3'b010;
localparam SCARV_COP_ICLASS_LOADSTORE    = 3'b011;
localparam SCARV_COP_ICLASS_RANDOM       = 3'b100;
localparam SCARV_COP_ICLASS_MOVE         = 3'b101;
localparam SCARV_COP_ICLASS_MP           = 3'b110;
localparam SCARV_COP_ICLASS_BITWISE      = 3'b111;
    
localparam SCARV_COP_SCLASS_CMOV      = 4'b1000;
localparam SCARV_COP_SCLASS_CMOVN     = 4'b1010;
localparam SCARV_COP_SCLASS_GPR2XCR    = 4'b0001;
localparam SCARV_COP_SCLASS_XCR2GPR    = 4'b0000;

localparam SCARV_COP_SCLASS_PPERM_W    = 4'b0000;
localparam SCARV_COP_SCLASS_PPERM_H0   = 4'b0010;
localparam SCARV_COP_SCLASS_PPERM_H1   = 4'b0011;
localparam SCARV_COP_SCLASS_PPERM_B0   = 4'b0100;
localparam SCARV_COP_SCLASS_PPERM_B1   = 4'b0101;
localparam SCARV_COP_SCLASS_PPERM_B2   = 4'b0110;
localparam SCARV_COP_SCLASS_PPERM_B3   = 4'b0111;
    
localparam SCARV_COP_SCLASS_SCATTER_B = 4'd0 ;
localparam SCARV_COP_SCLASS_GATHER_B  = 4'd1 ;
localparam SCARV_COP_SCLASS_SCATTER_H = 4'd2 ;
localparam SCARV_COP_SCLASS_GATHER_H  = 4'd3 ;
localparam SCARV_COP_SCLASS_ST_W     = 4'd4 ;
localparam SCARV_COP_SCLASS_LD_W     = 4'd5 ;
localparam SCARV_COP_SCLASS_ST_H     = 4'd6 ;
localparam SCARV_COP_SCLASS_LH_CR     = 4'd7 ;
localparam SCARV_COP_SCLASS_ST_B     = 4'd8 ;
localparam SCARV_COP_SCLASS_LB_CR     = 4'd9 ;
    
localparam SCARV_COP_SCLASS_MIX_L = 4'd0;
localparam SCARV_COP_SCLASS_MIX_H = 4'd1;
localparam SCARV_COP_SCLASS_BOP  = 4'd2;
localparam SCARV_COP_SCLASS_INS  = 4'd3; 
localparam SCARV_COP_SCLASS_EXT  = 4'd4;
localparam SCARV_COP_SCLASS_LD_LI  = 4'd5;
localparam SCARV_COP_SCLASS_LD_HI  = 4'd6;

localparam SCARV_COP_SCLASS_PADD  = 4'd1;
localparam SCARV_COP_SCLASS_PSUB  = 4'd2;
localparam SCARV_COP_SCLASS_PMUL_L  = 4'd3;
localparam SCARV_COP_SCLASS_PSLL  = 4'd4;
localparam SCARV_COP_SCLASS_PSRL  = 4'd5;
localparam SCARV_COP_SCLASS_PROT  = 4'd6;
localparam SCARV_COP_SCLASS_PSLL_I = 4'd7;
localparam SCARV_COP_SCLASS_PSRL_I = 4'd8;
localparam SCARV_COP_SCLASS_PROT_I = 4'd9;

localparam SCARV_COP_SCLASS_MEQU  = 4'd0 ;
localparam SCARV_COP_SCLASS_MLTE  = 4'd1 ;
localparam SCARV_COP_SCLASS_MGTE  = 4'd2 ;
localparam SCARV_COP_SCLASS_MADD_3 = 4'd3 ;
localparam SCARV_COP_SCLASS_MADD_2 = 4'd4 ;
localparam SCARV_COP_SCLASS_MSUB_3 = 4'd5 ;
localparam SCARV_COP_SCLASS_MSUB_2 = 4'd6 ;
localparam SCARV_COP_SCLASS_MSLL_I = 4'd7 ;
localparam SCARV_COP_SCLASS_MSLL  = 4'd8 ;
localparam SCARV_COP_SCLASS_MSRL_I = 4'd9 ;
localparam SCARV_COP_SCLASS_MSRL  = 4'd10;
localparam SCARV_COP_SCLASS_MACC_2 = 4'd11;
localparam SCARV_COP_SCLASS_MACC_1 = 4'd12;
localparam SCARV_COP_SCLASS_MMUL_1  = 4'd13;

localparam SCARV_COP_SCLASS_RSEED   = 4'b1010;
localparam SCARV_COP_SCLASS_RSAMP   = 4'b1011;

localparam SCARV_COP_RNG_TYPE_LFSR32= 0;

localparam SCARV_COP_PW_1           = 3'b000;
localparam SCARV_COP_PW_2           = 3'b001;
localparam SCARV_COP_PW_4           = 3'b010;
localparam SCARV_COP_PW_8           = 3'b011;
localparam SCARV_COP_PW_16          = 3'b100;
