
#
# This test tries to assemble a single version of every instruction.
#

.text

main:

#
# ------------------------------------------------------------

    xc.ldr.b    a0,a1(a2)
    xc.ldr.h    a0,a1(a2)
    xc.ldr.w    a0,a1(a2)
    xc.ldr.bu    a0,a1(a2)
    xc.ldr.hu    a0,a1(a2)
    
    xc.str.b    a0,a1(a2)
    xc.str.h    a0,a1(a2)
    xc.str.w    a0,a1(a2)

    xc.mmul.3   (a1,a0),a2,a3,a4
    xc.macc.1   (a1,a0),a2,a3,a4
    xc.madd.3   (a1,a0),a2,a3,a4
    xc.msub.3   (a1,a0),a2,a3,a4

    xc.mror    (a1,a0), a2,a3,a4

    xc.rngtest a0
    xc.rngsamp a0
    xc.rngseed a0

    xc.lut  a0,a1,a2
    xc.bop  a0,a1,a2,1

    xc.padd     h,a0,a1,a2
    xc.psub     h,a0,a1,a2
    xc.pror     h,a0,a1,a2
    xc.psll     h,a0,a1,a2
    xc.psrl     h,a0,a1,a2
    xc.pror.i   h,a0,a2,1
    xc.psll.i   h,a0,a2,1
    xc.psrl.i   h,a0,a2,1

    xc.pmul.l   h,a0,a1,a2
    xc.pmul.h   h,a0,a1,a2

    xc.pclmul.l h,a0,a1,a2
    xc.pclmul.h h,a0,a1,a2

    xc.scatter.b a0,a1,a2
    xc.scatter.h a0,a1,a2

    xc.gather.b a0,a1,a2
    xc.gather.h a0,a1,a2

    xc.aessub.enc       a0,a1,a2
    xc.aessub.encrot    a0,a1,a2
    xc.aessub.dec       a0,a1,a2
    xc.aessub.decrot    a0,a1,a2
    xc.aesmix.enc       a0,a1,a2
    xc.aesmix.dec       a0,a1,a2

    xc.sha256.s0  a0, a1
    xc.sha256.s1  a0, a1
    xc.sha256.s2  a0, a1
    xc.sha256.s3  a0, a1

    xc.sha3.xy    a0, a1, a2, 0
    xc.sha3.x1    a0, a1, a2, 0
    xc.sha3.x2    a0, a1, a2, 0
    xc.sha3.x4    a0, a1, a2, 0
    xc.sha3.yx    a0, a1, a2, 0

