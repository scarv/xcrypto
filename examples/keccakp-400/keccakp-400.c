
#include <stdint.h>
#include "common.h"
#include "benchmark.h"

#include "scarv/KeccakP-400-SnP.h"

void rand_init_state(tKeccak400Lane * state) {
    for(int i = 0; i < KeccakP400_stateSizeInBytes/2; i ++) {
        uint32_t sample;
        rngsamp(&sample);
        state[i] = (tKeccak400Lane)sample;
    }
}

int main() {
  
    tKeccak400Lane keccak_state1 [KeccakP400_stateSizeInBytes/2];
    tKeccak400Lane keccak_state2 [KeccakP400_stateSizeInBytes/2];

    rand_init_state(keccak_state1);

    XC_BENCHMARK_INIT;
    XC_BENCHMARK_SET(keccakp400_opt,KeccakP400Tester)
    XC_BENCHMARK_SET(keccakp400_ref,KeccakP400Tester)
    
    for(int i = 0; i < KeccakP400_stateSizeInBytes/2; i ++) {
        keccak_state2[i] = keccak_state1[i];

        /*puthex((uint32_t)keccak_state1[i]);
        putstr(", ");
        puthex((uint32_t)keccak_state2[i]);
        putstr("\n");*/
    }
    putstr("\n");
    
    
    uint32_t rounds      = 1;

    putstr("# Running KeccakP-400\n");
    
    uint32_t acc_instr_start = rdinstret();
    uint32_t acc_cycle_start = rdcycle();
    KeccakP400Round(keccak_state1,0);
    uint32_t acc_instr_count = rdinstret() - acc_instr_start;
    uint32_t acc_cycle_count = rdcycle()   - acc_cycle_start;
    
    XC_BENCHMARK_RECORD(opt)
    XC_BENCHMARK_RECORD_ADD_METRIC(
        opt, cycles, putstr("0x");puthex(acc_cycle_count)
    )
    XC_BENCHMARK_RECORD_ADD_METRIC(
        opt, instrs, putstr("0x");puthex(acc_instr_count)
    )
    XC_BENCHMARK_SET_ADD(keccakp400_opt, opt)
    
    uint32_t ref_instr_start = rdinstret();
    uint32_t ref_cycle_start = rdcycle();
    KeccakP400RoundReference(keccak_state2,0);
    uint32_t ref_instr_count = rdinstret() - ref_instr_start;
    uint32_t ref_cycle_count = rdcycle()   - ref_cycle_start;

    XC_BENCHMARK_RECORD(ref)
    XC_BENCHMARK_RECORD_ADD_METRIC(
        ref, cycles, putstr("0x");puthex(ref_cycle_count)
    )
    XC_BENCHMARK_RECORD_ADD_METRIC(
        ref, instrs, putstr("0x");puthex(ref_instr_count)
    )
    XC_BENCHMARK_SET_ADD(keccakp400_ref, ref)

    
    for(int i = 0; i < KeccakP400_stateSizeInBytes/2; i ++) {
        putchar('#');
        puthex(keccak_state1[i]);
        putstr(", ");
        puthex(keccak_state2[i]);

        if(keccak_state1[i] != keccak_state2[i]) {
            putstr(" !");
        }

        putstr("\n");
    }
    putstr("\n");
    
    XC_BENCHMARK_SET_REPORT(keccakp400_ref);
    XC_BENCHMARK_SET_REPORT(keccakp400_opt);

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
