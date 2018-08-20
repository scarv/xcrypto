

AS      = $(COP_HOME)/work/riscv-binutils-gdb/build/gas/as-new
OBJDUMP = $(COP_HOME)/work/riscv-binutils-gdb/build/binutils/objdump

ASFLAGS += -march=rv32imx -mabi=ilp32 -fpic

SRC     ?= cop-instructions.S
OUT_OBJ := $(addprefix $(COP_WORK)/,$(SRC:%.S=%.o))
OUT_DIS := $(addprefix $(COP_WORK)/,$(SRC:%.S=%.dis))

all: $(OUT_OBJ) $(OUT_DIS)

${COP_WORK}/%.o : %.S
	$(AS) $(ASFLAGS) $(INC_DIRS) -c -o $@ $^

${COP_WORK}/%.dis : $(COP_WORK)/%.o
	$(OBJDUMP) -j.text -dt $< > $@

.PHONY: clean
clean:
	echo $(OUT_OBJ) $(OUT_DIS)
