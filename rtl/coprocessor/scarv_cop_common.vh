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

localparam SCARV_COP_ICLASS_PACKED_ARITH = 4'b0001;
localparam SCARV_COP_ICLASS_TWIDDLE      = 4'b0010;
localparam SCARV_COP_ICLASS_LOADSTORE    = 4'b0011;
localparam SCARV_COP_ICLASS_RANDOM       = 4'b0100;
localparam SCARV_COP_ICLASS_MOVE         = 4'b0101;
localparam SCARV_COP_ICLASS_MP           = 4'b0110;
localparam SCARV_COP_ICLASS_BITWISE      = 4'b0111;
localparam SCARV_COP_ICLASS_AES          = 4'b1000;
    
localparam SCARV_COP_SCLASS_CMOV_T    = 5'b11010;
localparam SCARV_COP_SCLASS_CMOV_F    = 5'b11100;
localparam SCARV_COP_SCLASS_GPR2XCR   = 5'b00001;
localparam SCARV_COP_SCLASS_XCR2GPR   = 5'b00000;

localparam SCARV_COP_SCLASS_PPERM_W   = 5'b0000;
localparam SCARV_COP_SCLASS_PPERM_H0  = 5'b0010;
localparam SCARV_COP_SCLASS_PPERM_H1  = 5'b0011;
localparam SCARV_COP_SCLASS_PPERM_B0  = 5'b0100;
localparam SCARV_COP_SCLASS_PPERM_B1  = 5'b0101;
localparam SCARV_COP_SCLASS_PPERM_B2  = 5'b0110;
localparam SCARV_COP_SCLASS_PPERM_B3  = 5'b0111;
    
localparam SCARV_COP_SCLASS_SCATTER_B = 5'd0 ;
localparam SCARV_COP_SCLASS_GATHER_B  = 5'd1 ;
localparam SCARV_COP_SCLASS_SCATTER_H = 5'd2 ;
localparam SCARV_COP_SCLASS_GATHER_H  = 5'd3 ;
localparam SCARV_COP_SCLASS_ST_W      = 5'd4 ;
localparam SCARV_COP_SCLASS_LD_W      = 5'd5 ;
localparam SCARV_COP_SCLASS_ST_H      = 5'd6 ;
localparam SCARV_COP_SCLASS_LH_CR     = 5'd7 ;
localparam SCARV_COP_SCLASS_ST_B      = 5'd8 ;
localparam SCARV_COP_SCLASS_LB_CR     = 5'd9 ;
    
localparam SCARV_COP_SCLASS_MIX_L     = 5'd0;
localparam SCARV_COP_SCLASS_MIX_H     = 5'd1;
localparam SCARV_COP_SCLASS_BOP       = 5'd2;
localparam SCARV_COP_SCLASS_INS       = 5'd3; 
localparam SCARV_COP_SCLASS_EXT       = 5'd4;
localparam SCARV_COP_SCLASS_LD_LIU    = 5'd5;
localparam SCARV_COP_SCLASS_LD_HIU    = 5'd6;

localparam SCARV_COP_SCLASS_PADD      = 5'b00001;
localparam SCARV_COP_SCLASS_PSUB      = 5'b00010;
localparam SCARV_COP_SCLASS_PMUL_L    = 5'b00011;
localparam SCARV_COP_SCLASS_PMUL_H    = 5'b00100;
localparam SCARV_COP_SCLASS_PCLMUL_L  = 5'b10011;
localparam SCARV_COP_SCLASS_PCLMUL_H  = 5'b10100;
localparam SCARV_COP_SCLASS_PSLL      = 5'b00101;
localparam SCARV_COP_SCLASS_PSRL      = 5'b00110;
localparam SCARV_COP_SCLASS_PROT      = 5'b00111;
localparam SCARV_COP_SCLASS_PSLL_I    = 5'b01000;
localparam SCARV_COP_SCLASS_PSRL_I    = 5'b01001;
localparam SCARV_COP_SCLASS_PROT_I    = 5'b01010;

localparam SCARV_COP_SCLASS_MEQU      = 5'd0 ;
localparam SCARV_COP_SCLASS_MLTE      = 5'd1 ;
localparam SCARV_COP_SCLASS_MGTE      = 5'd2 ;
localparam SCARV_COP_SCLASS_MADD_3    = 5'd3 ;
localparam SCARV_COP_SCLASS_MADD_2    = 5'd4 ;
localparam SCARV_COP_SCLASS_MSUB_3    = 5'd5 ;
localparam SCARV_COP_SCLASS_MSUB_2    = 5'd6 ;
localparam SCARV_COP_SCLASS_MSLL_I    = 5'd7 ;
localparam SCARV_COP_SCLASS_MSLL      = 5'd8 ;
localparam SCARV_COP_SCLASS_MSRL_I    = 5'd9 ;
localparam SCARV_COP_SCLASS_MSRL      = 5'd10;
localparam SCARV_COP_SCLASS_MACC_2    = 5'd11;
localparam SCARV_COP_SCLASS_MACC_1    = 5'd12;
localparam SCARV_COP_SCLASS_MMUL_3    = 5'd13;
localparam SCARV_COP_SCLASS_MCLMUL_3  = 5'd14;

localparam SCARV_COP_SCLASS_RSEED     = 5'd0;
localparam SCARV_COP_SCLASS_RSAMP     = 5'd1;
localparam SCARV_COP_SCLASS_RTEST     = 5'd2;

localparam SCARV_COP_SCLASS_AESSUB_ENC    = 5'b00010;
localparam SCARV_COP_SCLASS_AESSUB_ENCROT = 5'b00110;
localparam SCARV_COP_SCLASS_AESSUB_DEC    = 5'b01010;
localparam SCARV_COP_SCLASS_AESSUB_DECROT = 5'b01110;
localparam SCARV_COP_SCLASS_AESMIX_ENC    = 5'b00011;
localparam SCARV_COP_SCLASS_AESMIX_DEC    = 5'b01011;

localparam SCARV_COP_RNG_TYPE_LFSR32= 0;

localparam SCARV_COP_PW_1           = 3'b000;
localparam SCARV_COP_PW_2           = 3'b001;
localparam SCARV_COP_PW_4           = 3'b010;
localparam SCARV_COP_PW_8           = 3'b011;
localparam SCARV_COP_PW_16          = 3'b100;
