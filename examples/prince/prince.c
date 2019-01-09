
#include "common.h"
#include "benchmark.h"

#include "scarv/prince.h"

uint64_t prince_test_vectors[][4] = {
// plaintext       ,  k0              ,  k1              ,  cipher
{0x0000000000000000,0x0000000000000000,0x0000000000000000,0x818665aa0d02dfda},
{0xffffffffffffffff,0x0000000000000000,0x0000000000000000,0x604ae6ca03c20ada},
{0x0000000000000000,0xffffffffffffffff,0x0000000000000000,0x9fb51935fc3df524},
{0x0000000000000000,0x0000000000000000,0xffffffffffffffff,0x78a54cbe737bb7ef},
{0x0123456789abcdef,0x0000000000000000,0xfedcba9876543210,0xae25ad3ca8fa9ccf},
};


int main() {
    
    putstr("\n# Prince Test\n");
    
    uint32_t instr = 0;
    uint32_t cycle = 0;

    XC_BENCHMARK_INIT;
    XC_BENCHMARK_SET(prince, PrinceTester);

    for(int i = 0; i < 5; i ++) {
        
        uint64_t plaintext = prince_test_vectors[i][0];
        uint64_t k0        = prince_test_vectors[i][1];
        uint64_t k1        = prince_test_vectors[i][2];
        uint64_t cipher    = prince_test_vectors[i][3];

        instr = rdinstret();
        cycle = rdcycle();
        uint64_t result_enc = prince_enc(plaintext, k0, k1);
        instr = rdinstret() - instr;
        cycle = rdcycle()   - cycle;

        putchar('#');
        puthex64(plaintext); putstr(", ");
        puthex64(k0       ); putstr(", ");
        puthex64(k1       ); putstr(", ");
        puthex64(cipher   ); putstr("\n");

        XC_BENCHMARK_RECORD(p_rec)
        XC_BENCHMARK_RECORD_ADD_INPUT(p_rec,putstr("0x");puthex64(plaintext))
        XC_BENCHMARK_RECORD_ADD_INPUT(p_rec,putstr("0x");puthex64(k0))
        XC_BENCHMARK_RECORD_ADD_INPUT(p_rec,putstr("0x");puthex64(k1))
        XC_BENCHMARK_RECORD_ADD_OUTPUT(p_rec,putstr("0x");puthex64(cipher))
        XC_BENCHMARK_RECORD_ADD_METRIC(p_rec, cycles, putstr("0x");puthex(cycle))
        XC_BENCHMARK_RECORD_ADD_METRIC(p_rec, instrs, putstr("0x");puthex(instr))
        XC_BENCHMARK_SET_ADD(prince, p_rec)

        if(result_enc != cipher) {
            putstr("\n#Test "); puthex(i); putstr(" Encrypt Failed\n");
            putstr("#Expected: "); puthex64(cipher); putstr("\n");
            putstr("#     Got: "); puthex64(result_enc); putstr("\n");
            __fail();
        }

        uint64_t result_dec = prince_dec(cipher   , k0, k1);

        if(result_dec != plaintext) {
            putstr("\n#Test "); puthex(i); putstr(" Decrypt Failed\n");
            putstr("#Expected: "); puthex64(plaintext); putstr("\n");
            putstr("#     Got: "); puthex64(result_dec); putstr("\n");
            __fail();
        }

        putstr("#PASS");
    
        putstr("# - Cycle Count: ");
        puthex(cycle);
        putstr(", Instr Count: ");
        puthex(instr);
        putstr("\n");


    }

    XC_BENCHMARK_SET_REPORT(prince);
    //
    // Don't assert correctness for Prince in Python, since the checking
    // is done here.
    //XC_BENCHMARK_SET_PASS(prince);
    
    __pass();
}
