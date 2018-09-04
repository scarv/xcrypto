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

`endif
