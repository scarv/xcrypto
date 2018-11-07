
.text

test_start:

    xc.ld.hiu  c0, 0xF4F3
    xc.ld.liu  c0, 0xF2F1
    xc.ld.hiu  c1, 0x1111
    xc.ld.liu  c1, 0x1111

    xc.aessub.enc    c2, c0, c1
    xc.xcr2gpr       a0, c2

    xc.aessub.decrot c2, c0, c1
    xc.xcr2gpr       a0, c2
    
    xc.aessub.encrot c2, c0, c1
    xc.xcr2gpr       a0, c2

    xc.aessub.dec    c2, c0, c1
    xc.xcr2gpr       a0, c2

    xc.aesmix.enc    c2, c0, c1
    xc.xcr2gpr       a0, c2

    xc.aesmix.dec    c2, c0, c1
    xc.xcr2gpr       a0, c2
