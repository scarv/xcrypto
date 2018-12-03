

export CC       = $(RISCV)/bin/riscv64-unknown-elf-gcc
export AS       = $(RISCV)/bin/riscv64-unknown-elf-as
export LD       = $(RISCV)/bin/riscv64-unknown-elf-ld
export X_AS     = $(XC_HOME)/work/riscv-binutils-gdb/build/gas/as-new
export X_OBJDUMP= $(XC_HOME)/work/riscv-binutils-gdb/build/binutils/objdump
export X_OBJCOPY= $(XC_HOME)/work/riscv-binutils-gdb/build/binutils/objcopy

export INC_DIR  = -I$(XC_HOME)/examples/common -I$(LIBSCARV)/build/include

export ASFLAGS  += -march=rv32imx -mabi=ilp32 

export CFLAGS   += -mabi=ilp32 -march=rv32im -O2 -Wall $(INC_DIR) \
                  -nostartfiles -nostdlib

export LDSCRIPT ?= $(XC_HOME)/examples/common/linker.ld

export LDFLAGS  += -T$(LDSCRIPT)

all:
	$(MAKE) -C integration-test all
	$(MAKE) -C helloworld all
	$(MAKE) -C mpn all
	$(MAKE) -C aes-test all

clean:
	$(MAKE) -C integration-test clean
	$(MAKE) -C helloworld clean
	$(MAKE) -C mpn clean
	$(MAKE) -C aes-test clean
