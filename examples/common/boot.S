
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
    li sp, 0xC0008000

    j   main


.global irq_handler
irq_handler:            # Un-handled -> infinite loop.
    j irq_handler;


#
# Put character function
#
.global putchar
putchar:                # Simple asm implmentation of putchar.
    li  t0, 0xFFFFFFFF
    sb  a0, 0(t0)       # Writes low byte of a0 to address 0xFFFFFFFF
    ret

#
# Put string function
#
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

#
# puts function, implemented as per the C std library
#
.global puts
puts:
    call    putstr     # Immediately call putstr
    li      t1, 0xA    # Load newline char
    sb      t1, 0(t0)  # store to 0 address loaded by putstr.
    li      a0, 0      # Return 0 indicating success
    ret

#
# Function for printing unsigned decimal numbers as hex to "stdout"
#
.global puthex
puthex:             
    li  t0, 0xFFFFFFFF
    la  t1, puthex_lut
    li  a2, 28
    
    puthex_loop:

        srl  a1, a0, a2     # Copy integer to write and shift down by a2
        addi a2, a2, -4     #
        andi t2, a1, 0xF    # Get nibble to print/convert to hex
        add  t3, t2, t1     # Offset into puthex_lut
        lbu  t3, 0(t3)      # Load char from hexlut.
        sb   t3, 0(t0)      # Store to stdout
        bgez a2, puthex_loop

    ret


#
# Function for printing unsigned decimal numbers as hex to "stdout"
#
.global puthex8
puthex8:             
    li  t0, 0xFFFFFFFF
    la  t1, puthex_lut

    srli a1, a0, 4      # Copy integer to write and shift down by 4 
    
    andi a0, a0, 0xF    # a0 = LS nibble
    andi a1, a1, 0xF    # a1 = MS nibble
    
    add  a0, a0, t1     # Offset into puthex_lut
    add  a1, a1, t1     # Offset into puthex_lut
    
    lbu  a1, 0(a1)      # Load char from hexlut.
    lbu  a0, 0(a0)      # Load char from hexlut.

    sb   a1, 0(t0)      # Store to stdout
    sb   a0, 0(t0)      # Store to stdout

    ret

.data
puthex_lut:
    .string "0123456789ABCDEFx"


.text

#
# Function for seeding the XCrypto RNG
#
.global rngseed
rngseed:
    xc.ld.w     c0, 0(a0)
	xc.rngseed  c0
    ret

#
# Function for reading a single random number from the XCrypto module.
#
.global rngsamp
rngsamp:
	xc.rngsamp  c0
    xc.st.w     c0, 0(a0)
    ret

#
# Function for checking if the RNG is "good"
#
.global rngtest
rngtest:
	xc.rngtest  a0
    ret


# Read the memory loads performance counter
.global rdloads
rdloads:
    lw  a0, -256(zero)
    ret

# Read the memory stores performance counter
.global rdstores
rdstores:
    lw  a0, -252(zero)
    ret

# Clear the memory loads performance counter
.global clrloads
clrloads:
    sw  zero, -256(zero)
    ret

# Clear the memory stores performance counter
.global clrstores
clrstores:
    sw  zero, -252(zero)
    ret
