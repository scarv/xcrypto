
.text

test_start:

    xc.ld.hiu  c0, 0x4553
    xc.ld.liu  c0, 0x13db
    xc.ld.hiu  c1, 0x4553
    xc.ld.liu  c1, 0x13db

    xc.aesmix.enc    c2, c0, c1
    xc.xcr2gpr       a0, c2

    xc.aesmix.dec    c3, c2, c2
    xc.xcr2gpr       a0, c3

    xc.ld.hiu  c0, 0x0101
    xc.ld.liu  c0, 0x0101
    xc.ld.hiu  c1, 0x0101
    xc.ld.liu  c1, 0x0101

    xc.aesmix.enc    c2, c0, c1
    xc.xcr2gpr       a0, c2

    xc.aesmix.dec    c3, c2, c2
    xc.xcr2gpr       a0, c3

    xc.ld.hiu  c0, 0xc6c6
    xc.ld.liu  c0, 0xc6c6
    xc.ld.hiu  c1, 0xc6c6
    xc.ld.liu  c1, 0xc6c6

    xc.aesmix.enc    c2, c0, c1
    xc.xcr2gpr       a0, c2
    
    xc.aesmix.dec    c3, c2, c2
    xc.xcr2gpr       a0, c3
    
    xc.ld.hiu  c0, 0xd5d4
    xc.ld.liu  c0, 0xd4d4
    xc.ld.hiu  c1, 0xd5d4
    xc.ld.liu  c1, 0xd4d4

    xc.aesmix.enc    c2, c0, c1
    xc.xcr2gpr       a0, c2
    
    xc.aesmix.dec    c3, c2, c2
    xc.xcr2gpr       a0, c3
