
.section .text

.section .text.boot_vector
.global boot_vector
boot_vector:
    j reset_handler     # We land here post-reset

.section .text.irq_vector
.global irq_vector
irq_vector:             # We land here on an interrupt
    j irq_handler

.section .text.__fail
.global __fail
__fail:                 # Fail target for self checking tests
    nop
    nop
    j __fail

.section .text.__pass
.global __pass
__pass:                 # Pass target for self checking tests.
    nop
    nop
    j __pass

.section .text

.global reset_handler
reset_handler:
    li  x1 , 0 # Zero all of the GPRs
    li  x2 , 0
    li  x3 , 0
    li  x4 , 0
    li  x5 , 0
    li  x6 , 0
    li  x7 , 0
    li  x8 , 0
    li  x9 , 0
    li  x10, 0
    li  x11, 0
    li  x12, 0
    li  x13, 0
    li  x14, 0
    li  x15, 0
    li  x16, 0
    li  x17, 0
    li  x18, 0
    li  x19, 0
    li  x20, 0
    li  x21, 0
    li  x22, 0
    li  x23, 0
    li  x24, 0
    li  x25, 0
    li  x26, 0
    li  x27, 0
    li  x28, 0
    li  x29, 0
    li  x30, 0
    li  x31, 0

    # Setup the stack pointer
    li sp, 0x2000

    j   main


.global irq_handler
irq_handler:            # Un-handled -> infinite loop.
    j irq_handler;


.global putchar
putchar:                # Simple asm implmentation of putchar.
    li  t0, 0xFFFFFFFF
    sb  a0, 0(t0)       # Writes low byte of a0 to address 0xFFFFFFFF
    ret

.global putstr
putstr:                # Simple asm implmentation of putchar.
    li  t0, 0xFFFFFFFF

    putchar_loop:

        lbu  t1, 0(a0)
        beqz t1, putchar_finish
        addi a0, a0, 1
        sb   t1, 0(t0)
        j    putchar_loop

    putchar_finish:
        ret
