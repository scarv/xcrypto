
YS_INSTALL  ?= $(YOSYS_INSTALL)
YS          ?= $(YS_INSTALL)/yosys
YSMTBMC     ?= $(YS_INSTALL)/yosys-smtbmc
YS_SCRIPT   ?= write-smt.ys

YS_SOLVER   ?= z3
YS_VCD      ?= $(ROP_HOME)/work/yosys.vcd

TB_DIR  = $(ROP_HOME)/verif/
RTL_DIR = $(ROP_HOME)/rtl/

TB_SRC  = $(TB_DIR)/tb_yosys.v
PR_SRC  = $(shell find $(ROP_HOME)/verif/proofs -name "*.v")
RTL_SRC = $(shell find $(RTL_DIR) -name "*.v")
ALL_SRC = $(TB_SRC) $(RTL_DIR) $(PR_SRC)

SMT2_out= $(ROP_HOME)/work/tb_yosys.smt2

STEPS ?= 20

all: $(SMT2_out) prove-bmc prove-induction

smt2: $(SMT2_out)

$(SMT2_out) : $(ALL_SRC) $(YS_SCRIPT)
	$(YS) -l $(ROP_HOME)/work/yosys.log $(YS_SCRIPT)

.PHONY: prove-induction clean

make-trace: $(SMT2_out)
	$(YSMTBMC) --presat -g -t $(STEPS) --dump-vcd $(YS_VCD) -s $(YS_SOLVER) $<

prove-induction: $(SMT2_out) prove-bmc
	$(YSMTBMC) --presat -i -t $(STEPS) --dump-vcd $(YS_VCD) -s $(YS_SOLVER) $<

prove-bmc: $(SMT2_out)
	$(YSMTBMC) --presat -t $(STEPS) --dump-vcd $(YS_VCD) -s $(YS_SOLVER) $<


clean:
	rm -rf $(YS_VCD) $(SMT2_out)
