
TGT_DIR  = $(COP_WORK)/examples

EXE      ?= $(TGT_DIR)/integration-test.elf

all: $(EXE) $(EXE:%.elf=%.dis) $(EXE:%.elf=%.hex)

$(TGT_DIR)/%.o : %.x.S
	-mkdir -p $(TGT_DIR)
	$(X_AS) $(ASFLAGS) $(INC_DIRS) -c -o $@ $^

$(TGT_DIR)/%.o : ../common/%.S
	-mkdir -p $(TGT_DIR)
	$(AS) $(ASFLAGS) $(INC_DIRS) -c -o $@ $^

$(TGT_DIR)/%.dis : $(TGT_DIR)/%.elf
	-mkdir -p $(TGT_DIR)
	$(X_OBJDUMP) -j.text -dt $< > $@

$(TGT_DIR)/integration-test.o: integration-test.c
	-mkdir -p $(TGT_DIR)
	$(CC) $(CFLAGS) -c -o $@ $^ $(LDFLAGS)

$(TGT_DIR)/integration-test.elf : $(TGT_DIR)/integration-test.o \
                                  $(TGT_DIR)/copmv.o \
                                  $(TGT_DIR)/boot.o
	$(CC)  $(LDFLAGS) $(CFLAGS) -o $@ $^

$(TGT_DIR)/%.hex : $(TGT_DIR)/%.elf
	$(X_OBJDUMP) -D -j.text $< | grep -P ":\t" > $@
	sed -i 's/     .*$///' $@
	sed -i 's/^.*:\t//' $@

.PHONY: clean
clean:
	rm -f $(OUT_OBJ) $(OUT_DIS)
