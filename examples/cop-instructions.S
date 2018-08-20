
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
    
    mv2cop  c15, x15
    mv2gpr  x15, c15
    add.px  w,c3,c1,c2
    sub.px  h,c3,c1,c2
    srl.px  w,c3,c1,c2
    roti.px n,c3,c1, 3
    srli.px b,c3,c1, 2+1
    rseed.cr c12
    rsamp.cr c15
    cmov.cr  c4,c5,c6
    cmovn.cr  c4,c5,c6
    scatter.b c8,c8,a0
    gather.b  c8,c8,a0
    scatter.h c2,c11,a0
    gather.h  c2,c11,a0
    lmix.cr   c9, c10, c11, 0
    hmix.cr   c9, c10, c11, 14
    bop.cr    c9, c10, c11, 0b0110
    equ.mp    c1,c2,c3,t0
    gtu.mp    c1,c2,c3,t1
    ltu.mp    c1,c2,c3,t1
    add3.mp   (c2,c3), c2,c3,c4
    add2.mp   (c0,c1), c2,c3
    sll.mp    (c0,c1), c2,c3,c4
    slli.mp   (c0,c1), c2,c3,4
    lw.cr     c9, 8(t1)
    lw.cr     c9, 0(t1)
    lhu.cr    c9,(1), 1022(t1)
    lbu.cr    c9,(1,0), 1023(t1)
    sw.cr     c9, 8(t1)
    sh.cr     c9,(1), 8(t1)
    sb.cr     c9,(1,0), 8(t1)
    lui.cr    c15, 0xffff
    lli.cr    c15, 0xffff
    twid.b    c0,c1, 3,1,2,0
    twid.n0   c0,c1, 3,1,2,0
    twid.n1   c0,c1, 3,1,2,0
    twid.c0   c0,c1, 3,1,2,0
    twid.c1   c0,c1, 3,1,2,0
    twid.c2   c0,c1, 3,1,2,0
    twid.c3   c0,c1, 3,1,2,0
    ins.cr    c6,c7, 0, 10
    ext.cr    c6,c7, 0, 10
