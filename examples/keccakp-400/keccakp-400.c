
#include <stdint.h>
#include "common.h"

#include "scarv/KeccakP-400-SnP.h"

void rand_init_state(tKeccakLane * state) {
    for(int i = 0; i < KeccakP400_stateSizeInBytes/2; i ++) {
        uint32_t sample;
        rngsamp(&sample);
        state[i] = (tKeccakLane)sample;
    }
}

int main() {
  
    tKeccakLane keccak_state1 [KeccakP400_stateSizeInBytes/2];
    tKeccakLane keccak_state2 [KeccakP400_stateSizeInBytes/2];

    rand_init_state(keccak_state1);

    
    for(int i = 0; i < KeccakP400_stateSizeInBytes/2; i ++) {
        keccak_state2[i] = keccak_state1[i];

        /*puthex((uint32_t)keccak_state1[i]);
        putstr(", ");
        puthex((uint32_t)keccak_state2[i]);
        putstr("\n");*/
    }
    putstr("\n");
    
    
    uint32_t rounds      = 1;

    putstr("Running KeccakP-400\n");
    
    uint32_t acc_instr_start = rdinstret();
    uint32_t acc_cycle_start = rdcycle();
    KeccakP400Round(keccak_state1,0);
    uint32_t acc_instr_count = rdinstret() - acc_instr_start;
    uint32_t acc_cycle_count = rdcycle()   - acc_cycle_start;
    
    uint32_t ref_instr_start = rdinstret();
    uint32_t ref_cycle_start = rdcycle();
    KeccakP400RoundReference(keccak_state2,0);
    uint32_t ref_instr_count = rdinstret() - ref_instr_start;
    uint32_t ref_cycle_count = rdcycle()   - ref_cycle_start;

    
    for(int i = 0; i < KeccakP400_stateSizeInBytes/2; i ++) {
        puthex(keccak_state1[i]);
        putstr(", ");
        puthex(keccak_state2[i]);

        if(keccak_state1[i] != keccak_state2[i]) {
            putstr(" !");
        }

        putstr("\n");
    }
    putstr("\n");
    

    putstr("# Reference\n");
    putstr("#   Cycle Count: ");
    puthex(ref_cycle_count);
    putstr("\n#   Instr Count: ");
    puthex(ref_instr_count);
    putstr("\n");
    putstr("# Accelerated\n");
    putstr("#   Cycle Count: ");
    puthex(acc_cycle_count);
    putstr("\n#   Instr Count: ");
    puthex(acc_instr_count);
    putstr("\n");

    __pass();
}
