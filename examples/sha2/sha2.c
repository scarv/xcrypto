
#include "common.h"
#include "benchmark.h"

#include "scarv/sha2_256.h"

void dump_bytes(uint8_t * b, uint32_t len) {
    putstr("'");
    for(int j = 0; j < len; j ++) {
        puthex8(b[j]);
    }
    putstr("'");
}

int main() {
    
    const uint32_t  input_len   = 32;
    const uint32_t  hash_len    = 32;

    uint8_t         input_bytes [input_len];
    uint8_t         hash        [hash_len ];

    for(int i = 0; i < input_len; i ++) {
        input_bytes[i] = i & 0xFF;
    }

    putstr("import hashlib\n");
    putstr("import binascii\n");
    putstr("import sys\n");
    
    XC_BENCHMARK_INIT;
    XC_BENCHMARK_SET(sha256,SHA256Tester)

    for(int i = 0; i < 10; i  ++) {
    
        XC_BENCHMARK_RECORD(rec)

        XC_BENCHMARK_RECORD_ADD_INPUT(rec, dump_bytes(input_bytes,input_len));

        uint32_t cycles = rdcycle();
        uint32_t iret   = rdinstret();
        sha2_256(hash, 1, input_bytes, input_len);
        cycles = rdcycle() - cycles;
        iret   = rdinstret() - iret;
        
        XC_BENCHMARK_RECORD_ADD_OUTPUT(rec,dump_bytes(hash,hash_len));
        XC_BENCHMARK_RECORD_ADD_METRIC(rec,cycles,putstr("0x");puthex(cycles))
        XC_BENCHMARK_RECORD_ADD_METRIC(rec,instrs,putstr("0x");puthex(iret))
        XC_BENCHMARK_SET_ADD(sha256, rec)
        
        for(int j = 0; j < hash_len; j ++) {
            input_bytes[j] = hash[j];
        }

    }
    
    XC_BENCHMARK_SET_REPORT(sha256);
    XC_BENCHMARK_SET_PASS(sha256);

    __pass();
}
