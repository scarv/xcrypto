
RTL_TIMEOUT =  1000
RTL_WAVES   ?= $(ROP_HOME)/work/waves.vcd

ICARUS  = iverilog
IRUN    = vvp

TB_DIR  = $(ROP_HOME)/verif/
RTL_DIR = $(ROP_HOME)/rtl/

TB_SRC  = $(shell find $(TB_DIR) -name "tb_icarus.v")
RTL_SRC = $(shell find $(RTL_DIR) -name "*.v")

SIM     = $(ROP_HOME)/work/icarus/isim

DEFINES = 

all: $(SIM)

$(SIM) : $(TB_SRC) $(RTL_SRC)
	-mkdir -p $(dir $(SIM))
	$(ICARUS) -I$(RTL_DIR) -I$(TB_DIR) \
        $(DEFINES) -g2012 -o $(SIM) $^


run: $(SIM)
	$(IRUN) $(SIM) +TIMEOUT=$(RTL_TIMEOUT) +WAVES=$(RTL_WAVES)

.PHONY: clean
clean:
	rm -rf ./work/icarus
