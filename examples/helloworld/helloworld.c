
#include "common.h"

#include "scarv/mpn.h"

int main() {
    
    putstr("\nPrinting Some Things...\n\n");
    putstr("Hello World!\n");
    putstr("This is being written by the PicoRV32!\n");
    for(int i = 0; i < 32; i ++) {
        putstr("i = ");
        puthex(i);
        putstr("\n");
    }

    putstr("\nTesting RNG...\n\n");
    uint32_t random = 32;
    uint32_t rtest      ;

    rngseed(&random);

    for(int i = 0; i < 32; i ++) {
        putstr("i = ");
        
        rngsamp(&random);
        rtest = rngtest();
        
        puthex(rtest);
        putstr(" - ");
        puthex(random);
        putstr("\n");
    }
    
    putstr("\nTesting MPN Add...\n\n");

    limb_t mpn_ret;
    limb_t mpn_r  [4];
    limb_t mpn_a  [4];
    limb_t mpn_b  [4];

    mpn_a[0] = 0xF0000004;
    mpn_b[0] = 0xF0000008;
    mpn_a[1] = 0xF0000004;
    mpn_b[1] = 0xF0000008;
    mpn_a[2] = 0xF0000004;
    mpn_b[2] = 0xF0000008;
    mpn_a[3] = 0xF0000004;
    mpn_b[3] = 0xF0000008;

    uint32_t start_t = rdcycle();
    uint32_t start_i = rdinstret();
    mpn_ret = mpn_add(mpn_r, mpn_a, 4, mpn_b, 4);
    uint32_t end_t   = rdcycle();
    uint32_t end_i   = rdinstret();

    putstr("  0x");
    for(int i =3; i > 0; i --) {
        puthex(mpn_a[i]);
    }
    putstr("\n+ 0x");
    for(int i =3; i > 0; i --) {
        puthex(mpn_b[i]);
    }
    putstr("\n= 0x");
    for(int i =3; i > 0; i --) {
        puthex(mpn_r[i]);
    }
    putstr("\n+ 0x");
    puthex(mpn_ret);
    putstr("\n");

    putstr("Cycles: "); puthex(end_t-start_t); putstr("\n");
    putstr("Instrs: "); puthex(end_i-start_i); putstr("\n");

    __pass();
}
