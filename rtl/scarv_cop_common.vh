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

`ifndef SCARV_COP_COMMON_VH
`define SCARV_COP_COMMON_VH

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
    
    
localparam SCARV_COP_SCLASS_SCATTER_B = 4'd0 ;
localparam SCARV_COP_SCLASS_GATHER_B  = 4'd1 ;
localparam SCARV_COP_SCLASS_SCATTER_H = 4'd2 ;
localparam SCARV_COP_SCLASS_GATHER_H  = 4'd3 ;
localparam SCARV_COP_SCLASS_SW_CR     = 4'd4 ;
localparam SCARV_COP_SCLASS_LW_CR     = 4'd5 ;
localparam SCARV_COP_SCLASS_SHU_CR    = 4'd6 ;
localparam SCARV_COP_SCLASS_LH_CR     = 4'd7 ;
localparam SCARV_COP_SCLASS_SBU_CR    = 4'd8 ;
localparam SCARV_COP_SCLASS_LB_CR     = 4'd9 ;
    
localparam SCARV_COP_SCLASS_LMIX_CR = 4'd0;
localparam SCARV_COP_SCLASS_HMIX_CR = 4'd1;
localparam SCARV_COP_SCLASS_BOP_CR  = 4'd2;
localparam SCARV_COP_SCLASS_INS_CR  = 4'd3; 
localparam SCARV_COP_SCLASS_EXT_CR  = 4'd4;
localparam SCARV_COP_SCLASS_LLI_CR  = 4'd5;
localparam SCARV_COP_SCLASS_LUI_CR  = 4'd6;

`endif
