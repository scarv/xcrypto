
OUT_DIR     ?= $(COP_WORK)/unit

INPUTS      ?= $(shell find -name "*.S")
OUTPUTS     ?= $(addprefix $(OUT_DIR)/, $(INPUTS:%.S=%.hex))

AS           = $(COP_HOME)/work/riscv-binutils-gdb/build/gas/as-new
OBJDUMP      = $(COP_HOME)/work/riscv-binutils-gdb/build/binutils/objdump

all: $(OUTPUTS)

$(OUT_DIR)/%.o : %.S
	@mkdir -p $(OUT_DIR)
	$(AS) -march=rv32ix -o $@ $<

$(OUT_DIR)/%.hex : $(OUT_DIR)/%.o
	$(OBJDUMP) -D -j.text $< | grep -P ":\t" > $@
	sed -i 's/     .*$///' $@
	sed -i 's/^.*:\t//' $@

clean:
	rm -rf $(OUTPUTS)
