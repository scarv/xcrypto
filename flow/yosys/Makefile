
YS_INSTALL  ?= $(YOSYS_INSTALL)
YS          ?= $(YS_INSTALL)yosys
YSMTBMC     ?= $(YS_INSTALL)yosys-smtbmc
YS_SCRIPT   ?= write-smt.ys

YS_SOLVER   ?= z3
YS_VCD      ?= $(COP_HOME)/work/yosys.vcd

SRC_RTL     ?= $(find $(COP_HOME) -path "rtl/*.v")
SRC_VERIF   ?= $(find $(COP_HOME) -path "verif/*.v")

SMT2_out= $(COP_HOME)/work/yosys_tb.smt2

all: $(SMT2_out)

$(SMT2_out) : $(YS_SCRIPT) $(SRC_RTL) $(SRC_VERIF)
	$(YS) -QT -l $(COP_HOME)/work/yosys.log $(YS_SCRIPT)


clean:
	rm -rf $(YS_VCD) $(SMT2_out)
