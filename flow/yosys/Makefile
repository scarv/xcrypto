
YS_INSTALL  ?= $(YOSYS_INSTALL)
YS          ?= $(YS_INSTALL)yosys
YSMTBMC     ?= $(YS_INSTALL)yosys-smtbmc
YS_SCRIPT   ?= write-smt-tb.ys

BMC_STEPS   ?= 10

SBY         ?= sby
SBY_SCRIPT  ?= proofs.sby
SBY_WORK    ?= $(COP_WORK)/sby

SRC_RTL     ?= $(shell find ../../ -path "*rtl/*.v") \
	           $(shell find ../../ -path "*rtl/*.vh")
SRC_VERIF   ?= $(shell find ../../ -path "*verif/*.vh") \
	           $(shell find ../../ -path "*verif/*.v") 

VLOG_out    = $(COP_HOME)/work/scarv_cop_top.v

LOG_SYNTH   = $(COP_HOME)/work/yosys-synth.log
LOG_SMT2    = $(COP_HOME)/work/smt2/synthesis.log

FML_CHECK_NAME  ?= correct_result_encodings
FML_TMP_FILE     = $(COP_WORK)/smt2/tmp.$(FML_CHECK_NAME)
SMT2_out        ?= $(COP_WORK)/smt2/$(FML_CHECK_NAME).smt2
SMT2_TRACE      ?= $(COP_WORK)/smt2/$(FML_CHECK_NAME).vcd
SMT2_VTB        ?= $(COP_WORK)/smt2/$(FML_CHECK_NAME).v

all: $(VLOG_out)

synthesise: $(VLOG_out)
$(VLOG_out) : YS_SCRIPT = write-verilog.ys
$(VLOG_out) : $(YS_SCRIPT) $(SRC_RTL)
	$(YS) -QT -l $(LOG_SYNTH) $(YS_SCRIPT)

.PHONY: adder
adder       : YS_SCRIPT = adder.ys
adder       : ../../rtl/coprocessor/scarv_cop_palu_adder.v
	$(YS) -QT $(YS_SCRIPT)

$(FML_TMP_FILE):
	touch $(FML_TMP_FILE)

.PHONY: smt2
smt2: $(SMT2_out)
$(SMT2_out) : $(SRC_RTL) $(SRC_VERIF) $(FML_TMP_FILE)
	-mkdir -p $(dir $(SMT2_out))
	$(YS) -QT -l $(LOG_SMT2) \
        -p"verilog_defaults -add -DFML_CHECK_NAME=$(FML_CHECK_NAME)" \
        -p"script $(YS_SCRIPT)" \
        -p"write_smt2 -wires $(SMT2_out)"

smt2-trace: $(SMT2_out)
	$(YSMTBMC) -t $(BMC_STEPS) \
               -g \
               --presat \
               --dump-vcd $(SMT2_TRACE) \
               -s z3 \
               $(SMT2_out)

.PHONY: formal
formal: $(SMT2_out)
	$(YSMTBMC) -t $(BMC_STEPS) \
               --presat \
               --dump-vcd $(SMT2_TRACE) \
               --dump-vlogtb $(SMT2_VTB) \
               -s z3 \
               $(SMT2_out)

clean:
	rm -rf $(COP_WORK)/smt2 $(SMT2_out) $(VLOG_out) $(SMT_VCD) $(LOG_SYNTH) \
        $(COP_WORK)/*.log $(COP_WORK)/*.rpt
