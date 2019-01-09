
#include <stdint.h>
#include "common.h"
#include "benchmark.h"

#include "scarv/KeccakP-1600-SnP.h"

void rand_init_state(tKeccak1600Lane * state) {
    for(int i = 0; i < 25; i ++) {
        uint64_t ta;
        uint32_t sample;
        rngsamp(&sample);
        ta |= sample;
        rngsamp(&sample);
        ta = (ta << 32) | sample;
        state[i] = (tKeccak1600Lane)ta;
    }
}

int main() {
  
    tKeccak1600Lane keccak_state1 [25];
    tKeccak1600Lane keccak_state2 [25];

    rand_init_state(keccak_state1);

    XC_BENCHMARK_INIT;
    XC_BENCHMARK_SET(keccakp1600_opt,KeccakP1600Tester)
    XC_BENCHMARK_SET(keccakp1600_ref,KeccakP1600Tester)
    
    for(int i = 0; i < 25; i ++) {
        keccak_state2[i] = keccak_state1[i];

        /*puthex64(keccak_state1[i]);
        putstr(", ");
        puthex64(keccak_state2[i]);
        putstr("\n");*/
    }
    putstr("\n");
    
    
    uint32_t rounds      = 1;

    putstr("# Running KeccakP-1600\n");
    
    uint32_t acc_instr_start = rdinstret();
    uint32_t acc_cycle_start = rdcycle();
    KeccakP1600Round(keccak_state1,2);
    uint32_t acc_instr_count = rdinstret() - acc_instr_start;
    uint32_t acc_cycle_count = rdcycle()   - acc_cycle_start;
    
    XC_BENCHMARK_RECORD(opt)
    XC_BENCHMARK_RECORD_ADD_METRIC(
        opt, cycles, putstr("0x");puthex(acc_cycle_count)
    )
    XC_BENCHMARK_RECORD_ADD_METRIC(
        opt, instrs, putstr("0x");puthex(acc_instr_count)
    )
    XC_BENCHMARK_SET_ADD(keccakp1600_opt, opt)
    
    uint32_t ref_instr_start = rdinstret();
    uint32_t ref_cycle_start = rdcycle();
    KeccakP1600RoundReference(keccak_state2,2);
    uint32_t ref_instr_count = rdinstret() - ref_instr_start;
    uint32_t ref_cycle_count = rdcycle()   - ref_cycle_start;

    XC_BENCHMARK_RECORD(ref)
    XC_BENCHMARK_RECORD_ADD_METRIC(
        ref, cycles, putstr("0x");puthex(ref_cycle_count)
    )
    XC_BENCHMARK_RECORD_ADD_METRIC(
        ref, instrs, putstr("0x");puthex(ref_instr_count)
    )
    XC_BENCHMARK_SET_ADD(keccakp1600_ref, ref)
    
    for(int i = 0; i < 25; i ++) {
        putchar('#');
        puthex64(keccak_state1[i]);
        putstr(", ");
        puthex64(keccak_state2[i]);

        if(keccak_state1[i] != keccak_state2[i]) {
            putstr(" !");
        }

        putstr("\n");
    }
    putstr("\n");
    
    XC_BENCHMARK_SET_REPORT(keccakp1600_ref);
    XC_BENCHMARK_SET_REPORT(keccakp1600_opt);

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
