#
# This test tries to assemble a single version of every instruction.
#

.text

main:

    mask.b2a       (a1,a0), (a3,a2)
    mask.a2b       (a1,a0), (a3,a2)

    mask.b.mask    (a1,a0), a2
    mask.b.unmask  a0,  (a3,a2)
    mask.b.remask  (a1,a0), (a3,a2)

    mask.a.mask    (a1,a0), a2
    mask.a.unmask  a0,  (a3,a2)
    mask.a.remask  (a1,a0), (a3,a2)

    mask.b.not     (a1,a0), (a3,a2)
    mask.b.and     (a1,a0), (a3,a2), (a5,a4)
    mask.b.nand    (a1,a0), (a3,a2), (a5,a4)
    mask.b.ior     (a1,a0), (a3,a2), (a5,a4)
    mask.b.xor     (a1,a0), (a3,a2), (a5,a4)
    mask.b.add     (a1,a0), (a3,a2), (a5,a4)
    mask.b.sub     (a1,a0), (a3,a2), (a5,a4)

    # These instructions might cause warnings...
    mask.b.and     (a1,a0), (a1,a0), (a5,a4)
    mask.b.and     (a1,a0), (a3,a2), (a1,a0)
