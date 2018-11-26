
#include <stdint.h>

#ifndef COMMON_H
#define COMMON_H

//! Signal the simulation has passed.
extern void     __pass();

//! Signal the simulation has failed.
extern void     __fail();

//! Write a character to stdout.
extern void putchar(int character);

//! Write a string to a stream.
extern void putstr(char * str);

//! Write a hexadecimal representation of a 32-bit number to stdout.
extern void puthex(uint32_t tp);

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

#endif
