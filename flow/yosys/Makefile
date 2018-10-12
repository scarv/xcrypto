
YS_INSTALL  ?= $(YOSYS_INSTALL)
YS          ?= $(YS_INSTALL)yosys
YSMTBMC     ?= $(YS_INSTALL)yosys-smtbmc
YS_SCRIPT   ?= write-smt-tb.ys

BMC_STEPS   ?= 7 

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

all: $(VLOG_out) formal-checks

synthesise: $(VLOG_out)
$(VLOG_out) : YS_SCRIPT = write-verilog.ys
$(VLOG_out) : $(YS_SCRIPT) $(SRC_RTL)
	$(YS) -QT -l $(LOG_SYNTH) $(YS_SCRIPT)

# --------------------------------------------------------------------------

FML_SWITCH_FILES =  $(shell find $(FE_DEFINES) -path "*.switches") 
FML_CONTEXTS     = $(basename $(notdir $(FML_SWITCH_FILES)))
FML_CONTEXT_JOBS = $(addprefix $(SMTDIR)/,$(addsuffix .fmljob,$(FML_CONTEXTS)))

FML_CONTEXT     ?= generic_instr_checks
FML_PROPERTIES   = $(shell cat $(FE_DEFINES)/$(FML_CONTEXT).switches)
FML_CONTEXT_DIR  = $(SMTDIR)/$(FML_CONTEXT)

SMTDIR   ?= $(COP_WORK)/smt2
SMT2_out ?= $(addsuffix .smt2,$(addprefix $(FML_CONTEXT_DIR)/,$(FML_PROPERTIES)))
SMT2_RPT ?= $(addsuffix .rpt,$(addprefix $(FML_CONTEXT_DIR)/,$(FML_PROPERTIES)))

all-context-jobs: $(SMT2_out) $(SMT2_RPT)

formal-checks: $(FML_CONTEXT_JOBS)

$(SMTDIR)/%.fmljob : $(FE_DEFINES)./%.switches
	$(MAKE) all-context-jobs FML_CONTEXT=$(basename $(notdir $@))

$(FML_CONTEXT_DIR)/%.smt2 : $(SRC_RTL) $(SRC_VERIF) $(FE_VERILOG) $(FE_DEFINES)
	-mkdir -p $(dir $(SMT2_out))
	$(YS) -qQT -l $@.log \
        -p"verilog_defaults -add -D$(basename $(notdir $@))" \
        -p"verilog_defaults -add -DPROPERTY_CONTEXT=_fvm_pc_$(FML_CONTEXT)" \
        -p"script $(YS_SCRIPT)" \
        -p"write_smt2 -wires $@"


$(FML_CONTEXT_DIR)/%.rpt : $(FML_CONTEXT_DIR)/%.smt2
	rm -f $@
	echo "`date` Started $(notdir $(basename $@))" > $@
	$(YSMTBMC) -t $(BMC_STEPS) \
               --dump-vcd $@.vcd \
               --noprogress \
               -s z3 \
               $< | tee -a $@
	echo "`date` Finished $(notdir $(basename $@))" >> $@

clean:
	rm -rf $(COP_WORK)/smt2 $(SMT2_out) $(VLOG_out) $(SMT_VCD) $(LOG_SYNTH) \
        $(COP_WORK)/*.log $(COP_WORK)/*.rpt
