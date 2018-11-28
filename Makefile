
ifndef XC_HOME
    $(error "Please run 'source ./bin/source.me.sh' to setup the project workspace")
endif

PARSE_OPCODES = $(XC_HOME)/bin/ise-parse-opcodes.py
OPCODES_SPEC  = $(XC_HOME)/docs/ise-opcodes.txt
RTL_DECODER   = $(XC_WORK)/ise_decode.v

UNIT_TESTS    = $(shell find . -path "./work/unit/*.hex")
UNIT_WAVES    = $(UNIT_TESTS:%.hex=%.vcd)

FORMAL_CHECKS = $(shell find ./verif/formal -name "fml_chk_*.v")
FORMAL_CHECK_NAMES = $(basename $(notdir $(FORMAL_CHECKS)))

export BMC_STEPS     ?= 10

export FML_CHECK_NAME = $(subst fml_chk_,,$(FORMAL_CHECK_NAMES))
export FML_ENGINE     = boolector

export SIM_UNIT_TEST ?= $(XC_WORK)/unit/00-mvcop.hex
export RTL_TIMEOUT   ?= 300

.PHONY: docs
docs:
	$(MAKE) -C $(XC_HOME)/docs all

#
# Build all of the assembly level examples of the ISE instructions
# into hex files. These can then be fed into the HDL simulator.
#
.PHONY: examples
examples: libscarv
	$(MAKE) -C $(XC_HOME)/examples all

.PHONY: libscarv
libscarv:
	$(MAKE) -C $(LIBSCARV) -f Makefile.arch-riscv-xcrypto objects lib disasm

libscarv-clean:
	$(MAKE) -C $(LIBSCARV) -f Makefile.arch-riscv-xcrypto spotless

.PHONY: clean
clean:
	$(MAKE) -C $(XC_HOME)/docs     clean
	$(MAKE) -C $(XC_HOME)/examples clean
	$(MAKE) -C $(XC_HOME)/verif/unit clean
	$(MAKE) -C $(XC_HOME)/flow/icarus clean
	$(MAKE) -C $(XC_HOME)/flow/yosys clean
	rm -f $(RTL_DECODER)

#
# Builds the RISC-V binutils with the patch applied to support assembly 
# of the ISE instructions.
#
binutils-gen: $(XC_WORK)/binutils-gen.h
$(XC_WORK)/binutils-gen.h: ./bin/ise-parse-opcodes.py ./docs/ise-opcodes.txt
	cat ./docs/ise-opcodes.txt | ./bin/ise-parse-opcodes.py -c > $@

#
# Generate verilog code for the ISE instruction decoder.
#
.PHONY: rtl_decoder
rtl_decoder: $(RTL_DECODER)
$(RTL_DECODER) : $(OPCODES_SPEC) $(PARSE_OPCODES)
	cat $< | $(PARSE_OPCODES) -verilog > $@


#
# Run the yosys formal flow
#
.PHONY: yosys_formal
yosys_formal: $(RTL_DECODER)
	$(MAKE) -C $(XC_HOME)/flow/yosys formal-checks

#
# Synthesis the verilog design using yosys
#
.PHONY: yosys_synth
yosys_synth: $(RTL_DECODER)
	$(MAKE) -C $(XC_HOME)/flow/yosys synthesise

#
# Build the Icarus Verilog based simulation model
#
.PHONY: icarus_build
icarus_build: $(RTL_DECODER)
	$(MAKE) -C $(XC_HOME)/flow/icarus sim

#
# Run the icarus based simulation model, accounting for the RTL_TIMEOUT
# and SIM_UNIT_TEST variables at the top of this file.
#
.PHONY: icarus_run
icarus_run: icarus_build unit_tests
	$(MAKE) -C $(XC_HOME)/flow/icarus run

#
# Run icaurus model on all unit tests
#
.PHONY: icarus_run_all
icarus_run_all : $(UNIT_WAVES) unit_tests
	-grep -m 1 --color -e "ERROR" $(XC_WORK)/unit/*.log

work/unit/%.vcd : $(XC_WORK)/unit/%.hex icarus_build
	$(MAKE) -C $(XC_HOME)/flow/icarus run \
        SIM_UNIT_TEST=$< \
        SIM_LOG=$(XC_WORK)/unit/$(notdir $@).log
	@mv $(XC_WORK)/icarus/unit-waves.vcd $@

#
# Build the icarus integration testbench
#
.PHONY: icarus_integ_tb
icarus_integ_tb:
	$(MAKE) -C $(XC_HOME)/flow/icarus integ-sim

#
# Build the icarus integration testbench
#
.PHONY: icarus_run_integ
icarus_run_integ: RTL_TIMEOUT = 3000
icarus_run_integ: examples
icarus_run_integ: icarus_integ_tb
	$(MAKE) -C $(XC_HOME)/flow/icarus integ-run

#
# Build the ISE unit tests into hex files for use with the Icarus
# simulation model.
#
.PHONY: unit_tests
unit_tests:
	$(MAKE) -C $(XC_HOME)/verif/unit all

.PHONY: verilator_build
verilator_build:
	$(MAKE) -C $(XC_HOME)/flow/verilator build

verilator_run: RTL_TIMEOUT=3000
verilator_run:
	$(MAKE) -C $(XC_HOME)/flow/verilator run

#
# Build the unit tests, examples yosys and icarus models but don't run 
# anything yet.
#
build_all: libscarv icarus_build unit_tests icarus_integ_tb examples docs verilator_build
