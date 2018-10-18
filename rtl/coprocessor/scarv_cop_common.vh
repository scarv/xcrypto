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

localparam SCARV_COP_SCLASS_TWID_B    = 4'b0000;
localparam SCARV_COP_SCLASS_TWID_N0   = 4'b0010;
localparam SCARV_COP_SCLASS_TWID_N1   = 4'b0011;
localparam SCARV_COP_SCLASS_TWID_C0   = 4'b0100;
localparam SCARV_COP_SCLASS_TWID_C1   = 4'b0101;
localparam SCARV_COP_SCLASS_TWID_C2   = 4'b0110;
localparam SCARV_COP_SCLASS_TWID_C3   = 4'b0111;
    
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
    
localparam SCARV_COP_SCLASS_LMIX_CR = 4'd0;
localparam SCARV_COP_SCLASS_HMIX_CR = 4'd1;
localparam SCARV_COP_SCLASS_BOP_CR  = 4'd2;
localparam SCARV_COP_SCLASS_INS_CR  = 4'd3; 
localparam SCARV_COP_SCLASS_EXT_CR  = 4'd4;
localparam SCARV_COP_SCLASS_LD_LI  = 4'd5;
localparam SCARV_COP_SCLASS_LD_HI  = 4'd6;

localparam SCARV_COP_SCLASS_ADD_PX  = 4'd1;
localparam SCARV_COP_SCLASS_SUB_PX  = 4'd2;
localparam SCARV_COP_SCLASS_MUL_PX  = 4'd3;
localparam SCARV_COP_SCLASS_SLL_PX  = 4'd4;
localparam SCARV_COP_SCLASS_SRL_PX  = 4'd5;
localparam SCARV_COP_SCLASS_ROT_PX  = 4'd6;
localparam SCARV_COP_SCLASS_SLLI_PX = 4'd7;
localparam SCARV_COP_SCLASS_SRLI_PX = 4'd8;
localparam SCARV_COP_SCLASS_ROTI_PX = 4'd9;

localparam SCARV_COP_SCLASS_EQU_MP  = 4'd0 ;
localparam SCARV_COP_SCLASS_LTU_MP  = 4'd1 ;
localparam SCARV_COP_SCLASS_GTU_MP  = 4'd2 ;
localparam SCARV_COP_SCLASS_ADD3_MP = 4'd3 ;
localparam SCARV_COP_SCLASS_ADD2_MP = 4'd4 ;
localparam SCARV_COP_SCLASS_SUB3_MP = 4'd5 ;
localparam SCARV_COP_SCLASS_SUB2_MP = 4'd6 ;
localparam SCARV_COP_SCLASS_SLLI_MP = 4'd7 ;
localparam SCARV_COP_SCLASS_SLL_MP  = 4'd8 ;
localparam SCARV_COP_SCLASS_SRLI_MP = 4'd9 ;
localparam SCARV_COP_SCLASS_SRL_MP  = 4'd10;
localparam SCARV_COP_SCLASS_ACC2_MP = 4'd11;
localparam SCARV_COP_SCLASS_ACC1_MP = 4'd12;
localparam SCARV_COP_SCLASS_MAC_MP  = 4'd13;

localparam SCARV_COP_SCLASS_RSEED   = 4'b1010;
localparam SCARV_COP_SCLASS_RSAMP   = 4'b1011;

localparam SCARV_COP_RNG_TYPE_LFSR32= 0;

localparam SCARV_COP_PW_1           = 3'b000;
localparam SCARV_COP_PW_2           = 3'b001;
localparam SCARV_COP_PW_4           = 3'b010;
localparam SCARV_COP_PW_8           = 3'b011;
localparam SCARV_COP_PW_16          = 3'b100;
