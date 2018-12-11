
#include <stddef.h>
#include <stdint.h>

#ifndef COMMON_H
#define COMMON_H

//! Signal the simulation has passed.
extern void     __pass();

//! Signal the simulation has failed.
extern void     __fail();

//! Write a character to stdout.
extern int  putchar(int character);

//! Write a string to a stream with no trailing '\n' character.
extern void putstr(char * str);

//! Write a string to a stream with a trailing '\n' character.
extern int  puts(char * str);

//! Write a hexadecimal representation of a 32-bit number to stdout.
extern void puthex(uint32_t tp);

//! Write a hexadecimal representation of a 64-bit number to stdout.
extern void puthex64(uint64_t tp) {
    uint32_t a = tp & 0xFFFFFFFF;
    uint32_t b = (tp >> 32) & 0xFFFFFFFF;
    puthex(b);
    puthex(a);
}

//! Read a random value from XCrypto.
extern void rngsamp(uint32_t * r);

//! Seed the RNG with a new value
extern void rngseed(uint32_t * r);

//! Is the RNG functioning correctly? (Self reporting)
extern uint32_t rngtest();

//! Sample the clock cycle counter (used for timing checks)
inline uint32_t rdcycle() {
    uint32_t tr;
    asm volatile ("rdcycle %0":"=r"(tr));
    return tr;
}

//! Sample the clock cycle counter (used for timing checks)
inline uint32_t rdinstret() {
    uint32_t tr;
    asm volatile ("rdinstret %0":"=r"(tr));
    return tr;
}

//! naieve memset implementation
void *memset(void *s, int c, size_t n){
    unsigned char * k = s;
    for(size_t i = 0; i < n; i ++) {
        k[i] = (unsigned char)c;
    }
    return s;
}

//! naieve memcpy implementation
void *memcpy(void *str1, const void *str2, size_t n) {
    unsigned char       * s1 = str1;
    const unsigned char * s2 = str2;
    for(size_t i = 0; i < n; i ++) {
        s1[i] = s2[i];
    }
    return str1;
}

#endif
