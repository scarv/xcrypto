
RTL_TIMEOUT=1000
RTL_WAVES  = $(COP_HOME)/work/waves.vcd
RTL_VECTOR = 
RTL_TRACE  =

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
        +VECTOR=$(RTL_VECTOR) +TRACE=$(RTL_TRACE)

.PHONY: clean
clean:
	rm -rf ./work/icarus
