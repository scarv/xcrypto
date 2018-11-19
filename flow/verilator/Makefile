
ifndef VERILATOR_ROOT
    $(error "Please set the VERILATOR_ROOT environment variable")
endif

VERILATOR   ?= $(VERILATOR_ROOT)/bin/verilator

SRC_RTL     ?= $(shell find ../../ -path "*rtl/coprocessor/*.v") \
	           $(shell find ../../ -path "*rtl/coprocessor/*.vh") \
               $(shell find ../../ -path "*rtl/integration/*.v") \
	           $(shell find ../../ -path "*rtl/integration/*.vh") \
               $(XC_HOME)/external/picorv32/picorv32.v  \
               $(XC_HOME)/verif/tb/axi_sram.v   \
               $(XC_HOME)/verif/tb/tb_integration.v


INTEG_TB    ?= tb_integration
SIM_EXE      = $(XC_HOME)/flow/verilator/obj_dir/$(INTEG_TB)
TOP_MODULE  ?= tb_integration

VL_FLAGS    ?= -Wall -top-module $(TOP_MODULE) \
	            -Wno-style -Wno-fatal \
                +define+NO_WAVE_DUMP=1+USE_VERILATOR_CLK_RESET=1 \
                -I$(XC_HOME)/rtl/coprocessor \
                -I$(XC_HOME)/work

all: build

build: $(SIM_EXE)

#
# Construct the verilated executable.
#
$(SIM_EXE) : $(SRC_RTL)
	$(VERILATOR) $(VL_FLAGS) --cc $(SRC_RTL) --exe vl_main.cpp -o $@
	$(MAKE) -C obj_dir -f V$(TOP_MODULE).mk

#
# Run the simulation executable
#
run: $(SIM_EXE)
	$(SIM_EXE) +TIMEOUT=$(RTL_TIMEOUT) \
                +IMEM=$(SIM_UNIT_TEST:%.hex=%.integ.hex) 
