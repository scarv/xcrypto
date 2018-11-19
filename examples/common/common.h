
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

#endif
