
ifndef VERILATOR_ROOT
    $(warning "Please set the VERILATOR_ROOT environment variable.")
    $(warning "See $(XC_ROOT)/flow/verilator/README.md")
    $(error   "Cannot continue without VERILATOR_ROOT")
endif

VERILATOR   ?= $(VERILATOR_ROOT)/bin/verilator

SRC_RTL     ?= $(shell find ../../ -path "*rtl/coprocessor/*.v") \
	           $(shell find ../../ -path "*rtl/coprocessor/*.vh") \
               $(shell find ../../ -path "*rtl/integration/*.v") \
	           $(shell find ../../ -path "*rtl/integration/*.vh") \
               $(XC_HOME)/external/picorv32/picorv32.v  \

CPP_FILES   = vl_main.cpp srec.cpp

TOP_MODULE  ?= scarv_prv_xcrypt_top
SIM_EXE      = $(XC_HOME)/work/verilator/$(TOP_MODULE)

VL_FLAGS    ?= -Wall -top-module $(TOP_MODULE) \
	            -Wno-style -Wno-fatal \
                --trace \
                +define+NO_WAVE_DUMP=1+USE_VERILATOR_CLK_RESET=1 \
                -I$(XC_HOME)/rtl/coprocessor \
                -I$(XC_HOME)/work

WAVES_FILE  ?= $(XC_HOME)/work/verilator/vl_waves.vcd

VERILATOR_TIMEOUT   ?= 300000
VERILATOR_PASS_ADDR ?= 0xC000001C
VERILATOR_FAIL_ADDR ?= 0xC0000010

all: build

build: $(SIM_EXE)

#
# Construct the verilated executable.
#
$(SIM_EXE) : $(SRC_RTL) $(CPP_FILES)
	@mkdir -p $(dir $(SIM_EXE))
	$(VERILATOR) $(VL_FLAGS) --cc $(SRC_RTL) --exe $(CPP_FILES) -o $@
	$(MAKE) -C obj_dir -f V$(TOP_MODULE).mk

#
# Run the simulation executable
#
run: RTL_TIMEOUT=$(VERILATOR_TIMEOUT)
run: $(SIM_EXE)
	@mkdir -p $(dir $(WAVES_FILE))
	$(SIM_EXE) +TIMEOUT=$(RTL_TIMEOUT) \
               +IMEM=$(SIM_UNIT_TEST:%.hex=%.srec) \
               +WAVES=$(WAVES_FILE) \
               +PASS_ADDR=$(VERILATOR_PASS_ADDR) \
               +FAIL_ADDR=$(VERILATOR_FAIL_ADDR) 
