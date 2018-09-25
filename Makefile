
ifndef COP_HOME
    $(error "Please run 'source ./bin/source.me.sh' to setup the project workspace")
endif

PARSE_OPCODES = $(COP_HOME)/bin/ise-parse-opcodes.py
OPCODES_SPEC  = $(COP_HOME)/docs/ise-opcodes.txt
RTL_DECODER   = $(COP_WORK)/ise_decode.v

UNIT_TESTS    = $(shell find . -path "./work/unit/*.hex")
UNIT_WAVES    = $(UNIT_TESTS:%.hex=%.vcd)

export SIM_UNIT_TEST ?= $(COP_WORK)/unit/00-mvcop.hex
export RTL_TIMEOUT   ?= 300

.PHONY: docs
docs:
	$(MAKE) -C $(COP_HOME)/docs all

#
# Build all of the assembly level examples of the ISE instructions
# into hex files. These can then be fed into the HDL simulator.
#
.PHONY: examples
examples:
	$(MAKE) -C $(COP_HOME)/examples all

.PHONY: clean
clean:
	$(MAKE) -C $(COP_HOME)/docs     clean
	$(MAKE) -C $(COP_HOME)/examples clean
	$(MAKE) -C $(COP_HOME)/verif/unit clean
	rm -f $(RTL_DECODER)

#
# Builds the RISC-V binutils with the patch applied to support assembly 
# of the ISE instructions.
#
binutils-gen: $(COP_WORK)/binutils-gen.h
$(COP_WORK)/binutils-gen.h: ./bin/ise-parse-opcodes.py ./docs/ise-opcodes.txt
	cat ./docs/ise-opcodes.txt | ./bin/ise-parse-opcodes.py -c > $@

#
# Generate verilog code for the ISE instruction decoder.
#
.PHONY: rtl_decoder
rtl_decoder: $(RTL_DECODER)
$(RTL_DECODER) : $(OPCODES_SPEC) $(PARSE_OPCODES)
	cat $< | $(PARSE_OPCODES) -verilog > $@


#
# Build the SMT2 model of the design using yosys for later feeding into
# the formal flow.
#
.PHONY: yosys_smt2
yosys_smt2: $(RTL_DECODER)
	$(MAKE) -C $(COP_HOME)/flow/yosys smt2

#
# Synthesis the verilog design using yosys
#
.PHONY: yosys_synth
yosys_synth: $(RTL_DECODER)
	$(MAKE) -C $(COP_HOME)/flow/yosys synthesise

#
# Build the Icarus Verilog based simulation model
#
.PHONY: icarus_build
icarus_build: $(RTL_DECODER)
	$(MAKE) -C $(COP_HOME)/flow/icarus sim

#
# Run the icarus based simulation model, accounting for the RTL_TIMEOUT
# and SIM_UNIT_TEST variables at the top of this file.
#
.PHONY: icarus_run
icarus_run: icarus_build unit_tests
	$(MAKE) -C $(COP_HOME)/flow/icarus run

#
# Run icaurus model on all unit tests
#
.PHONY: icarus_run_all
icarus_run_all : $(UNIT_WAVES)
	-grep -m 1 --color -e "ERROR" $(COP_WORK)/unit/*.log

work/unit/%.vcd : $(COP_WORK)/unit/%.hex icarus_build
	$(MAKE) -C $(COP_HOME)/flow/icarus run \
        SIM_UNIT_TEST=$< \
        SIM_LOG=$(COP_WORK)/unit/$(notdir $@).log
	@mv $(COP_WORK)/icarus/waves.vcd $@

#
# Build the icarus integration testbench
#
.PHONY: icarus_integ_tb
icarus_integ_tb:
	$(MAKE) -C $(COP_HOME)/flow/icarus integ-sim

#
# Build the icarus integration testbench
#
.PHONY: icarus_run_integ
icarus_run_integ: RTL_TIMEOUT = 3000
icarus_run_integ: examples
icarus_run_integ: icarus_integ_tb
	$(MAKE) -C $(COP_HOME)/flow/icarus integ-run

#
# Build the ISE unit tests into hex files for use with the Icarus
# simulation model.
#
.PHONY: unit_tests
unit_tests:
	$(MAKE) -C $(COP_HOME)/verif/unit all


#
# Build the yosys and icarus models but don't run anything yet.
#
build_all: yosys_smt2 icarus_build
