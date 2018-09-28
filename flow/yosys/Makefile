
YS_INSTALL  ?= $(YOSYS_INSTALL)
YS          ?= $(YS_INSTALL)yosys
YSMTBMC     ?= $(YS_INSTALL)yosys-smtbmc
YS_SCRIPT   ?= write-smt-tb.ys

SBY         ?= sby
SBY_SCRIPT  ?= proofs.sby
SBY_WORK    ?= $(COP_WORK)/sby

SMT2_out    ?= $(COP_WORK)/smt2/formal.smt2

SRC_RTL     ?= $(shell find ../../ -path "*rtl/*.v")
SRC_VERIF   ?= $(shell find ../../ -path "*verif/*.v")

VLOG_out    = $(COP_HOME)/work/scarv_cop_top.v

LOG_SYNTH   = $(COP_HOME)/work/yosys-synth.log
LOG_SMT2    = $(COP_HOME)/work/smt2/synthesis.log

PREP_MODEL  = $(COP_WORK)/model_ise_prep.ilang

all: $(VLOG_out)

synthesise: $(VLOG_out)
$(VLOG_out) : YS_SCRIPT = write-verilog.ys
$(VLOG_out) : $(YS_SCRIPT) $(SRC_RTL)
	$(YS) -QT -l $(LOG_SYNTH) $(YS_SCRIPT)

.PHONY: adder
adder       : YS_SCRIPT = adder.ys
adder       : ../../rtl/coprocessor/scarv_cop_palu_adder.v
	$(YS) -QT $(YS_SCRIPT)

$(PREP_MODEL) : $(COP_HOME)/verif/model/model_ise.v
	$(YS) -QT prep_ise_model.ys

.PHONY: smt2
smt2: $(SMT2_out)
$(SMT2_out) : $(SRC_RTL) $(SRC_VERIF)
	-mkdir -p $(dir $(SMT2_out))
	$(YS) -QT -l $(LOG_SMT2) $(YS_SCRIPT)

.PHONY: formal
formal:
	-rm -rf $(SBY_WORK)
	sby -d $(SBY_WORK) \
        --yosys $(YS) \
        --smtbmc $(YSMTBMC) \
        $(SBY_SCRIPT)

clean:
	rm -rf $(SMT2_out) $(VLOG_out) $(SMT_VCD) $(LOG_SYNTH) \
        $(COP_WORK)/*.log $(COP_WORK)/*.rpt
