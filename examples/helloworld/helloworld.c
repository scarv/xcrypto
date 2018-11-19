
#include "common.h"

int main() {
    putstr("Hello World!\n");
    putstr("This is being written by the PicoRV32!\n");
    for(int i = 0; i < 32; i ++) {
        putstr("i = ");
        puthex(i);
        putstr("\n");
    }
    __pass();
}
