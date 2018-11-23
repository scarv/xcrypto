
#include "common.h"

int main() {
    putstr("Hello World!\n");
    putstr("This is being written by the PicoRV32!\n");
    for(int i = 0; i < 32; i ++) {
        putstr("i = ");
        puthex(i);
        putstr("\n");
    }

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
    __pass();
}
