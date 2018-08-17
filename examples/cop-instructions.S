
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

_start:
    
    mv2cop  c1, a0
    #lw.cr   c2, a1, 16
    #add.px  0,0,0,c3,c1,c2
    #mv2gpr  a0, c3
