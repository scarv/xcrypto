
.text

test_start:

    xc.ld.hiu  c0, 0x00ab
    xc.ld.liu  c0, 0x5312
    xc.ld.hiu  c1, 0x5657
    xc.ld.liu  c1, 0xfffe

    xc.aessub.enc    c2, c0, c1
    xc.xcr2gpr       a0, c2

    xc.aessub.dec    c3, c2, c2
    xc.xcr2gpr       a0, c3

    xc.aessub.decrot c2, c0, c1
    xc.xcr2gpr       a0, c2
    
    xc.aessub.encrot c2, c0, c1
    xc.xcr2gpr       a0, c2
