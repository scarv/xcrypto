
RTL_TIMEOUT=200
RTL_WAVES  = $(COP_HOME)/work/icarus/waves.vcd
RTL_TRACE  =

SIM_UNIT_TEST ?= 

ICARUS      = iverilog
IRUN        = vvp

MANIFEST   ?= $(COP_HOME)/flow/icarus/manifest.cmd

SIM     = $(COP_HOME)/work/icarus/isim

DEFINES = 

all: $(SIM)

.PHONY: sim $(SIM)
sim: $(SIM)
$(SIM) :
	-mkdir -p $(dir $(SIM))
	$(ICARUS) -I$(COP_WORK) \
        $(DEFINES) -g2012 \
        -o $(SIM) \
        -c$(MANIFEST)

run: $(SIM)
	$(IRUN) $(SIM) +TIMEOUT=$(RTL_TIMEOUT) +WAVES=$(RTL_WAVES) \
        +VECTOR=$(SIM_UNIT_TEST) +TRACE=$(RTL_TRACE)

.PHONY: clean
clean:
	rm -rf ./work/icarus
