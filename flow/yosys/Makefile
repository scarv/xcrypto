
YS_INSTALL  ?= $(YOSYS_INSTALL)
YS          ?= $(YS_INSTALL)yosys
YSMTBMC     ?= $(YS_INSTALL)yosys-smtbmc
YS_SCRIPT   ?= write-smt-tb.ys

YS_SOLVER   ?= z3
YS_VCD      ?= $(COP_HOME)/work/yosys.vcd

SRC_RTL     ?= $(find $(COP_HOME) -path "rtl/coprocessor/*.v")
SRC_VERIF   ?= $(find $(COP_HOME) -path "verif/*.v")

SMT2_out    = $(COP_HOME)/work/yosys_tb.smt2
VLOG_out    = $(COP_HOME)/work/scarv_cop_top.v

SMT_STEPS   = 10
SMT_SOLVER  = z3
SMT_VCD     = $(COP_WORK)/smt.vcd

all: $(SMT2_out) $(VLOG_out)

smt2        : $(SMT2_out)
$(SMT2_out) : YS_SCRIPT = write-smt-tb.ys
$(SMT2_out) : $(YS_SCRIPT) $(SRC_RTL) $(SRC_VERIF)
	$(YS) -QT -l $(COP_HOME)/work/yosys-tb.log $(YS_SCRIPT)

synthesise: $(VLOG_out)
$(VLOG_out) : YS_SCRIPT = write-verilog.ys
$(VLOG_out) : $(YS_SCRIPT) $(SRC_RTL)
	$(YS) -QT -l $(COP_HOME)/work/yosys-synth.log $(YS_SCRIPT)

.PHONY: adder
adder       : YS_SCRIPT = adder.ys
adder       : ../../rtl/coprocessor/scarv_cop_palu_adder.v
	$(YS) -QT $(YS_SCRIPT)

formal-trace:
	$(YSMTBMC) -t $(SMT_STEPS) \
        -g \
        --presat \
        --dump-vcd $(SMT_VCD) \
        -s $(SMT_SOLVER) \
        $(SMT2_out)

clean:
	rm -rf $(YS_VCD) $(SMT2_out)
