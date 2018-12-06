
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

    /*
    for(int i = 0; i < KeccakP400_stateSizeInBytes/2; i ++) {
        keccak_state2[i] = keccak_state1[i];

        puthex((uint32_t)keccak_state1[i]);
        putstr(", ");
        puthex((uint32_t)keccak_state2[i]);
        putstr("\n");
    }
    putstr("\n");
    */
    
    uint32_t rounds      = 20;
    uint32_t instr_start = rdinstret();
    uint32_t cycle_start = rdcycle();

    putstr("Running 20 rounds of KeccakP-400\n");
    
    KeccakP400_Permute_20rounds(keccak_state1);

    //KeccakP400_rho(keccak_state1);
    //KeccakP400_rho_asm(keccak_state2);

    uint32_t instr_count = rdinstret() - instr_start;
    uint32_t cycle_count = rdcycle()   - cycle_start;

    /*
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
    */

    putstr("# Cycle Count: ");
    puthex(cycle_count);
    putstr("\n# Instr Count: ");
    puthex(instr_count);
    putstr("\n");
    putstr("# Cycle/Round: ");
    puthex(cycle_count/rounds);
    putstr("\n# Instr/Round: ");
    puthex(instr_count/rounds);
    putstr("\n");

    __pass();
}
