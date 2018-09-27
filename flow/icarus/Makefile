
RTL_TIMEOUT ?=200
RTL_WAVES   ?= $(COP_HOME)/work/icarus/unit-waves.vcd
RTL_TRACE    =

SIM_UNIT_TEST ?= 

ICARUS      = iverilog
IRUN        = vvp

MANIFEST        ?= $(COP_HOME)/flow/icarus/manifest.cmd
SIM              = $(COP_HOME)/work/icarus/isim-unit
SIM_LOG         ?= $(COP_HOME)/work/icarus/sim-unit.log

INTEG_MANIFEST  ?= $(COP_HOME)/flow/icarus/integration.cmd
INTEG_SIM        = $(COP_HOME)/work/icarus/isim-integ
INTEG_SIM_LOG   ?= $(COP_HOME)/work/icarus/sim-integ.log
INTEG_HEX_TMP    = $(COP_WORK)/unit/integ-tmp.hex

DEFINES = 

all: $(SIM)

#
# Build the simulation for the unit tests
#
.PHONY: sim $(SIM)
sim: $(SIM)
$(SIM) :
	-mkdir -p $(dir $(SIM))
	$(ICARUS) -I$(COP_WORK) \
        $(DEFINES) -g2012 \
        -o $(SIM) \
        -c$(MANIFEST)

#
# Run the simulation for the unit tests
#
run: $(SIM)
	$(IRUN) -l $(SIM_LOG) \
        $(SIM) \
        +TIMEOUT=$(RTL_TIMEOUT) \
        +WAVES=$(RTL_WAVES) \
        +VECTOR=$(SIM_UNIT_TEST) \
        +TRACE=$(RTL_TRACE)

#
# Build the integration testbench.
#
.PHONY: integ-sim $(INTEG_SIM)
integ-sim: $(INTEG_SIM)
$(INTEG_SIM) :
	-mkdir -p $(dir $(INTEG_SIM))
	$(ICARUS) -I$(COP_WORK) \
        $(DEFINES) -g2012 \
        -o $(INTEG_SIM) \
        -c$(INTEG_MANIFEST)

#
# Transform hex files for use with integration testbench
# This has to be done since the unit-testbench expects memory words,
# while the integration testbench expects bytes.
#
$(SIM_UNIT_TEST:%.hex=%.integ.hex) : $(SIM_UNIT_TEST)
	sed 's/\(..\)\(..\)\(..\)\(..\)/\4\n\3\n\2\n\1/g' $< > $@

#
# Run the integration testbench.
#
integ-run: RTL_WAVES=$(COP_HOME)/work/icarus/integ-waves.vcd
integ-run: $(INTEG_SIM) $(SIM_UNIT_TEST:%.hex=%.integ.hex)
	$(IRUN) -l $(INTEG_SIM_LOG) \
        $(INTEG_SIM) \
        +TIMEOUT=$(RTL_TIMEOUT) \
        +WAVES=$(RTL_WAVES) \
        +IMEM=$(SIM_UNIT_TEST:%.hex=%.integ.hex) \
        +TRACE=$(RTL_TRACE)

.PHONY: clean
clean:
	rm -rf ./work/icarus
