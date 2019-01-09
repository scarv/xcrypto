
BWORK       = $(XC_HOME)/work/benchmarks
SREC_DIR    = $(XC_HOME)/work/examples

BENCHMARKS  = mpn aes-test prince sha2 keccakp-1600 keccakp-400

BMARK_SRECS = $(addsuffix .srec,$(addprefix $(SREC_DIR)/,$(BENCHMARKS)))
BMARK_STDOUT= $(addsuffix .py,$(addprefix $(BWORK)/,$(BENCHMARKS)))

.PHONY: $(BMARK_SRECS)

$(BWORK)/%.py : $(SREC_DIR)/%.srec
	$(VERILATOR_SIM) +TIMEOUT=4000000 \
        +PASS_ADDR=0xC000001C +FAIL_ADDR=0xC0000010 \
        +IMEM=$< \
        +STDOUT=$@

all: $(BWORK) $(BMARK_STDOUT)

$(BWORK):
	mkdir -p $(BWORK)

clean:
	rm -rf $(BWORK)
