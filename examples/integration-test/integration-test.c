
#include <stdint.h>

#include "common.h"

extern void     __pass();
extern void     __fail();
extern void     __move_to_cop(uint32_t a);
extern uint32_t __move_to_gpr();

int main() {

    int sum = 0;

    for(int i = 0; i < 20; i ++) {
        
        int original = sum;

        __move_to_cop(sum);
    
        sum += i;

        int new = __move_to_gpr();

        if((original + i) != sum) {
            __fail();
        }

    }
    
    __pass();
}
