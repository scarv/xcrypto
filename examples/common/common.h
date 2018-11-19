
#ifndef COMMON_H
#define COMMON_H

//! Signal the simulation has passed.
extern void     __pass();

//! Signal the simulation has failed.
extern void     __fail();

//! Write a character to stdout.
extern int putchar(int character);

//! Write a string to a stream.
extern int putstr(char * str);

#endif
