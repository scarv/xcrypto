

CC      = $(RISCV)/bin/riscv64-unknown-elf-gcc
AS      = $(RISCV)/bin/riscv64-unknown-elf-as
OBJDUMP = $(RISCV)/bin/riscv64-unknown-elf-objdump

CCFLAGS += -E -Os -O2 -march=rv32im -mabi=ilp32 -nostartfiles -nostdlib -fpie

SRC     ?= aes-accelerated.S


all: ${COP_WORK}/aes-accelerated.o ${COP_WORK}/aes-accelerated.dis

${COP_WORK}/%.o : %.S
	$(CC) $(CCFLAGS) $(INC_DIRS) -c -o $@ $^

${COP_WORK}/%.dis : $(COP_WORK)/%.o
	$(OBJDUMP) -Dt $< > $@

