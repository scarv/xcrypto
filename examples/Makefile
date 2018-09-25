

export CC       = $(RISCV)/bin/riscv64-unknown-elf-gcc
export AS       = $(RISCV)/bin/riscv64-unknown-elf-as
export LD       = $(RISCV)/bin/riscv64-unknown-elf-ld
export X_AS     = $(COP_HOME)/work/riscv-binutils-gdb/build/gas/as-new
export X_OBJDUMP= $(COP_HOME)/work/riscv-binutils-gdb/build/binutils/objdump

export INC_DIR  = $(COP_HOME)/examples/common

export ASFLAGS  += -march=rv32ix -mabi=ilp32 

export CFLAGS   += -mabi=ilp32 -march=rv32i -O2 -Wall -I$(INC_DIR) \
                  -nostartfiles -nostdlib

export LDSCRIPT ?= $(COP_HOME)/examples/common/linker.ld

export LDFLAGS  += -T$(LDSCRIPT)

all:
	$(MAKE) -C integration-test all
