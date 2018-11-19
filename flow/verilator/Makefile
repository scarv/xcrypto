
ifndef VERILATOR_ROOT
    $(error "Please set the VERILATOR_ROOT environment variable")
endif

VERILATOR   ?= $(VERILATOR_ROOT)/bin/verilator

SRC_RTL     ?= $(shell find ../../ -path "*rtl/coprocessor/*.v") \
	           $(shell find ../../ -path "*rtl/coprocessor/*.vh") \
               $(shell find ../../ -path "*rtl/integration/*.v") \
	           $(shell find ../../ -path "*rtl/integration/*.vh") \
               $(XC_HOME)/external/picorv32/picorv32.v


INTEG_TB    ?= integ_tb
SIM_EXE      = $(XC_HOME)/flow/verilator/obj_dir/$(INTEG_TB)
TOP_MODULE  ?= scarv_prv_xcrypt_top

VL_FLAGS    ?= -Wall -top-module $(TOP_MODULE) \
	            -Wno-style -Wno-fatal \
                -I$(XC_HOME)/rtl/coprocessor \
                -I$(XC_HOME)/work

all: build

build: $(INTEG_TB)

$(INTEG_TB) : $(SRC_RTL)
	$(VERILATOR) $(VL_FLAGS) --cc $(SRC_RTL) --exe vl_main.cpp -o $@
	$(MAKE) -C obj_dir -f V$(TOP_MODULE).mk $(INTEG_TB)
