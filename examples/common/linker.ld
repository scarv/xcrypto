
SECTIONS {
    /* Trampoline for getting to the reset handler */
    .text 0x00000000 : { *(.text.boot_vector) }

    /* Trampoline for getting to the interrupt handler */
    .text 0x00000010 : { *(.text.irq_vector) }

    /* Pass and Fail addresses */
    .text : { *(.text.__fail) }
    .text : { *(.text.__pass) }

    /* The rest of the program code goes here */
    .text : { *(.text.*) }
    .data : { *(.data) }
    .bss  : { *(.bss ) }

    /* Don't include the .comment section anywhere */
    /DISCARD/ : { *(.comment) }
}


