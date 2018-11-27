
#include "common.h"

#include "scarv/mpn.h"
#include "scarv/limb.h"

// Maximum length of an MPN number to test.
#define MPN_MAXLEN  4

/*!
@brief Create a new random multi-precision number
@param mpn - pre-allocated buffer to hold the number
@param len - The length of the number.
*/
void gen_random_mpn (limb_t * mpn, uint32_t len) {

    int a = len > MPN_MAXLEN ? MPN_MAXLEN : len;

    for(int i = 0; i < a; i ++){
        rngsamp(&mpn[i]);
    }

}

/*!
@brief Set an MPN to zero.
*/
void zero_mpn (limb_t * mpn, uint32_t len) {
    
    for(int i = 0; i < len; i ++) {
        mpn[i] = 0;
    }
}


/*
@brief Prints a single operation, inputs and outputs as a python tuple.
*/
void dump_test_infix_2(
    char   * op, 
    limb_t * lhs,
    limb_t * rhs,
    int      lhs_len,
    int      rhs_len,
    limb_t * result,
    limb_t   carry,
    uint32_t cycles,
    uint32_t instrs
) {
    putchar('(');
    putstr(op); putchar(',');
    putstr("0x");
    for(int i =lhs_len; i >= 0; i --) {
        puthex(lhs[i]);
    }
    putchar(',');
    putstr("0x");
    for(int i =rhs_len; i >= 0; i --) {
        puthex(rhs[i]);
    }
    putchar(',');
    putstr("0x"); puthex(lhs_len); putchar(',');
    putstr("0x"); puthex(rhs_len); putchar(',');
    putstr("0x");
    for(int i =MPN_MAXLEN; i >= 0; i --) {
        puthex(result[i]);
    }
    putchar(',');
    putstr("0x"); puthex(carry); putchar(',');
    putstr("0x"); puthex(cycles); putchar(',');
    putstr("0x"); puthex(instrs);
    putchar(')');
}
            

#define RUN_MPN_TEST_CARRY(FUNCTION) { \
    zero_mpn(result, MPN_MAXLEN); \
    gen_random_mpn(input_lhs,lhs_len); \
    gen_random_mpn(input_rhs,rhs_len); \
    uint32_t start_t = rdcycle(); \
    uint32_t start_i = rdinstret(); \
    carry = FUNCTION(result, input_lhs, lhs_len, input_rhs, rhs_len); \
    cycles = rdcycle() - start_t; \
    instrs = rdinstret() - start_i; \
    dump_test_infix_2( \
        #FUNCTION,  \
        input_lhs, input_rhs,  \
        lhs_len, rhs_len, \
        result, carry,\
        cycles, instrs\
    ); \
}

#define RUN_MPN_TEST_NO_CARRY(FUNCTION) { \
    zero_mpn(result, MPN_MAXLEN); \
    gen_random_mpn(input_lhs,lhs_len); \
    gen_random_mpn(input_rhs,rhs_len); \
    uint32_t start_t = rdcycle(); \
    uint32_t start_i = rdinstret(); \
    FUNCTION(result, input_lhs, lhs_len, input_rhs, rhs_len); \
    cycles = rdcycle() - start_t; \
    instrs = rdinstret() - start_i; \
    dump_test_infix_2( \
        #FUNCTION,  \
        input_lhs, input_rhs,  \
        lhs_len, rhs_len, \
        result, 0,\
        cycles, instrs\
    ); \
}

int main() {

    limb_t   input_lhs [MPN_MAXLEN];
    limb_t   input_rhs [MPN_MAXLEN];
    limb_t   result    [MPN_MAXLEN];
    limb_t   carry;

    uint32_t cycles;
    uint32_t instrs;

    putstr("data=(");

    for (int lhs_len  = 1; lhs_len < MPN_MAXLEN; lhs_len ++) {

        for (int rhs_len  = 1; rhs_len < MPN_MAXLEN; rhs_len ++) {

            //
            // MPN_ADD
            //

            RUN_MPN_TEST_CARRY(mpn_add)
            putstr(",\n");

            //
            // MPN_SUB
            //
            
            RUN_MPN_TEST_CARRY(mpn_sub)
            putstr(",\n");

            //
            // MPN_MUL
            //
            
            RUN_MPN_TEST_NO_CARRY(mpn_mul)
            putstr(",\n");

        }

    }
    putstr(")\n");

    __pass();
}
