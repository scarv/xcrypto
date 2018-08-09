
##
## Register names and indexes
##
#define cpr0    0
#define cpr1    1
#define cpr2    2
#define cpr3    3
#define cpr4    4
#define cpr5    5
#define cpr6    6
#define cpr7    7
#define cpr8    8
#define cpr9    9
#define cpr10   10
#define cpr11   11
#define cpr12   12
#define cpr13   13
#define cpr14   14
#define cpr15   15
#define cpr16   16
#define cpr17   17
#define cpr18   18
#define cpr19   19
#define cpr20   20
#define cpr21   21
#define cpr22   22
#define cpr23   23
#define cpr24   24
#define cpr25   25
#define cpr26   26
#define cpr27   27
#define cpr28   28
#define cpr29   29
#define cpr30   30
#define cpr31   31

##
## Instruction field encodings
##
#define OPCODE      0b101011                 ## Major opcode prefix.

#define F3_REG      0b000
#define F3_SB_CR    0b001
#define F3_SH_CR    0b010
#define F3_SW_CR    0b011
#define F3_LBU_CR   0b100
#define F3_LHU_CR   0b101
#define F3_LW_CR    0b110
#define F3_TWID     0b111

#define F7_ADD_p1   0b0000000
#define F7_ADD_p2   0b0000001
#define F7_ADD_p4   0b0000010
#define F7_ADD_p8   0b0000011
#define F7_SUB_p1   0b0000100
#define F7_SUB_p2   0b0000101
#define F7_SUB_p4   0b0000110
#define F7_SUB_p8   0b0000111
#define F7_MUL_p1   0b0001000
#define F7_MUL_p2   0b0001001
#define F7_MUL_p4   0b0001010
#define F7_MUL_p8   0b0001011
#define F7_SLL_p1   0b0001100
#define F7_SLL_p2   0b0001101
#define F7_SLL_p4   0b0001110
#define F7_SLL_p8   0b0001111
#define F7_SRL_p1   0b0010000
#define F7_SRL_p2   0b0010001
#define F7_SRL_p4   0b0010010
#define F7_SRL_p8   0b0010011
#define F7_ROT_p1   0b0010100
#define F7_ROT_p2   0b0010101
#define F7_ROT_p4   0b0010110
#define F7_ROT_p8   0b0010111
#define F7_XORT     0b0011000
#define F7_ANDT     0b0011001
#define F7_ORT      0b0011010
#define F7_MVCOP    0b0011011
#define F7_MVGPR    0b0011011
#define F7_GATHER   0b0011100
#define F7_SCATTER  0b0011101

#define RS2_MVCOP   0b00000
#define RS2_MVGPR   0b00001

.macro INSN_s OP, F3, rd, rs1, simm12
    .word 0x0
.endm

.macro INSN_i OP, F3, rd, rs1, simm12
    .word 0x0
.endm

.macro INSN_r OP, F3, F7, rd, rs1, rs2
    .word 0x0
.endm

##
## Instruction macro definitions - S type
##
.macro SB_CR rd simm12 rs1 ; INSN_s OPCODE, F3_SB_CR, rd,rs1,simm12; .endm
.macro SH_CR rd simm12 rs1 ; INSN_s OPCODE, F3_SH_CR, rd,rs1,simm12; .endm
.macro SW_CR rd simm12 rs1 ; INSN_s OPCODE, F3_SW_CR, rd,rs1,simm12; .endm

##
## Instruction macro definitions - I type
##
.macro LBU_CR rd simm12 rs1;  INSN_i OPCODE, F3_LBU_CR, rd,rs1,simm12; .endm
.macro LHU_CR rd simm12 rs1;  INSN_i OPCODE, F3_LHU_CR, rd,rs1,simm12; .endm
.macro LW_CR  rd simm12 rs1;  INSN_i OPCODE, F3_LW_CR , rd,rs1,simm12; .endm
.macro TWID   rd rs1 b3 b2 b1 b0 
    INSN_i OPCODE, F3_TWID, rd,rs1, (b0 | (b1 << 2) | (b2<<4) | (b3 << 6))
.endm

##
## Instruction macro definitions - R type
##
.macro ADD_p1 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_ADD_p1, rd, rs1, rs2 ;.endm
.macro ADD_p2 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_ADD_p2, rd, rs1, rs2 ;.endm
.macro ADD_p4 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_ADD_p4, rd, rs1, rs2 ;.endm
.macro ADD_p8 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_ADD_p8, rd, rs1, rs2 ;.endm
.macro SUB_p1 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_SUB_p1, rd, rs1, rs2 ;.endm
.macro SUB_p2 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_SUB_p2, rd, rs1, rs2 ;.endm
.macro SUB_p4 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_SUB_p4, rd, rs1, rs2 ;.endm
.macro SUB_p8 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_SUB_p8, rd, rs1, rs2 ;.endm
.macro MUL_p1 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_MUL_p1, rd, rs1, rs2 ;.endm
.macro MUL_p2 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_MUL_p2, rd, rs1, rs2 ;.endm
.macro MUL_p4 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_MUL_p4, rd, rs1, rs2 ;.endm
.macro MUL_p8 rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_MUL_p8, rd, rs1, rs2 ;.endm
.macro SLL_p1 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SLL_p1, rd, rs1, SHA ;.endm
.macro SLL_p2 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SLL_p2, rd, rs1, SHA ;.endm
.macro SLL_p4 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SLL_p4, rd, rs1, SHA ;.endm
.macro SLL_p8 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SLL_p8, rd, rs1, SHA ;.endm
.macro SRL_p1 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SRL_p1, rd, rs1, SHA ;.endm
.macro SRL_p2 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SRL_p2, rd, rs1, SHA ;.endm
.macro SRL_p4 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SRL_p4, rd, rs1, SHA ;.endm
.macro SRL_p8 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_SRL_p8, rd, rs1, SHA ;.endm
.macro ROT_p1 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_ROT_p1, rd, rs1, SHA ;.endm
.macro ROT_p2 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_ROT_p2, rd, rs1, SHA ;.endm
.macro ROT_p4 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_ROT_p4, rd, rs1, SHA ;.endm
.macro ROT_p8 rd rs1 SHA ; INSN_r OPCODE,F3_REG,F7_ROT_p8, rd, rs1, SHA ;.endm
.macro XORT   rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_XORT  , rd, rs1, rs2 ;.endm
.macro ANDT   rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_ANDT  , rd, rs1, rs2 ;.endm
.macro ORT    rd rs1 rs2 ; INSN_r OPCODE,F3_REG,F7_ORT   , rd, rs1, rs2 ;.endm
.macro MVCOP  rd rs1     ; INSN_r OPCODE,F3_REG,F7_MVCOP , rd, rs1, RS2_MVCOP;.endm
.macro MVGPR  rd rs1     ; INSN_r OPCODE,F3_REG,F7_MVGPR , rd, rs1, RS2_MVGPR;.endm
.macro GATHER  rd rs1 rs2; INSN_r OPCODE,F3_REG,F7_GATHER, rd, rs1, rs2 ;.endm
.macro SCATTER rd rs1 rs2; INSN_r OPCODE,F3_REG,F7_SCATTER, rd, rs1, rs2 ;.endm
