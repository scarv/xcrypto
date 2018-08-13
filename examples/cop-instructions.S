
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

##
## Instruction field encodings
##
.section .text


#define insn_i_type(f3, b, h, rd, rs1, simm12) \
.word ((                0b101011)<< 0 ) | ((0b1111         &rd      )<< 7 ) | \
      ((0b1            &b       )<< 11) | \
      ((0b111          &f3      )<< 12) | \
      ((0b11111        &rs1     )<< 15) | \
      ((0b1            &h       )<< 19) | \
      ((0b111111111111 &simm12  )<< 20) 


#define LBU_cr(rd, h, b, imm, rs1) insn_i_type(001,b,h,rd,rs1,imm)

