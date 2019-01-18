
BWORK       = $(XC_HOME)/work/benchmarks
SREC_DIR    = $(XC_HOME)/work/examples
BLIB        = $(XC_HOME)/flow/benchmarks/XCBenchmark.py

BENCHMARKS  = mpn aes-test prince sha2 keccakp-1600 keccakp-400

BMARK_SRECS = $(addsuffix .srec,$(addprefix $(SREC_DIR)/,$(BENCHMARKS)))
BMARK_STDOUT= $(addsuffix .py,$(addprefix $(BWORK)/,$(BENCHMARKS)))
BMARK_RESULT= $(addsuffix .txt,$(addprefix $(BWORK)/results-,$(BENCHMARKS)))

$(BWORK)/%.py : $(SREC_DIR)/%.srec
	$(VERILATOR_SIM) +TIMEOUT=4000000 \
        +PASS_ADDR=0xC000001C +FAIL_ADDR=0xC0000010 \
        +IMEM=$< \
        +STDOUT=$@

$(BWORK)/results-%.txt : $(BWORK)/%.py $(BLIB)
	env PATH=$(PATH):$(XC_HOME)/flow/benchmarks \
	python3 $< > $@

all: $(BWORK) $(BMARK_STDOUT) $(BMARK_RESULT)

$(BWORK):
	mkdir -p $(BWORK)

clean:
	rm -rf $(BWORK)
