
ifndef COP_HOME
    $(error "Please run 'source ./bin/source.me.sh' to setup the project workspace")
endif

PARSE_OPCODES = $(COP_HOME)/bin/ise-parse-opcodes.py
OPCODES_SPEC  = $(COP_HOME)/docs/ise-opcodes.txt
RTL_DECODER   = $(COP_WORK)/ise_decode.v

export SIM_UNIT_TEST ?= $(COP_WORK)/unit/00-mvcop.hex

.PHONY: docs
docs:
	$(MAKE) -C $(COP_HOME)/docs all

.PHONY: examples
examples:
	$(MAKE) -C $(COP_HOME)/examples all

.PHONY: clean
clean:
	$(MAKE) -C $(COP_HOME)/docs     clean
	$(MAKE) -C $(COP_HOME)/examples clean
	rm -f $(RTL_DECODER)

binutils-gen: $(COP_WORK)/binutils-gen.h
$(COP_WORK)/binutils-gen.h: ./bin/ise-parse-opcodes.py ./docs/ise-opcodes.txt
	cat ./docs/ise-opcodes.txt | ./bin/ise-parse-opcodes.py -c > $@

.PHONY: rtl_decoder
rtl_decoder: $(RTL_DECODER)
$(RTL_DECODER) : $(OPCODES_SPEC) $(PARSE_OPCODES)
	cat $< | $(PARSE_OPCODES) -verilog > $@

.PHONY: yosys_smt2
yosys_smt2: $(RTL_DECODER)
	$(MAKE) -C $(COP_HOME)/flow/yosys all

.PHONY: icarus_build
icarus_build: $(RTL_DECODER)
	$(MAKE) -C $(COP_HOME)/flow/icarus sim

.PHONY: icarus_run
icarus_run: icarus_build
	$(MAKE) -C $(COP_HOME)/flow/icarus run

.PHONY: unit_tests
unit_tests:
	$(MAKE) -C $(COP_HOME)/verif/unit all

build_all: yosys_smt2 icarus_build
