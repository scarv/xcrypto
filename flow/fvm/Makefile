
FVM_WORK         ?= $(COP_WORK)/fvm
FVM_TOOL         ?= fegen.py

FE_SPECIFICATION ?= $(COP_HOME)/verif/formal/assertions.fvm
FE_VERILOG       ?= $(FVM_WORK)/property_contexts.v
FE_DEFINES       ?= $(FVM_WORK)/property_switches_
FE_MODULE_FILE   ?= $(FVM_WORK)/modules.txt

all: $(FE_VERILOG) $(FE_DEFINES) $(FE_MODULE_FILE)


$(FE_VERILOG) $(FE_DEFINES) : $(FE_SPECIFICATION)
	mkdir -p $(FVM_WORK)
	$(FVM_TOOL) --fe $(FE_SPECIFICATION) --backend verilog-yosys \
        --defines $(FE_DEFINES) \
        --output  $(FE_VERILOG)

$(FE_MODULE_FILE) : $(FE_VERILOG)
	grep -o "_fvm_pc_[a-zA-Z0-9_]* " $(FE_VERILOG) > $(FE_MODULE_FILE)
