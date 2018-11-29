
BWORK       = $(XC_HOME)/work/benchmarks

MPN_OUTPUT  = $(BWORK)/mpn-data-$(LIBSCARV_ARCH).py
MPN_PLOT    = $(BWORK)/mpn-plot-$(LIBSCARV_ARCH).svg
MPN_PROCESS = $(XC_HOME)/flow/benchmarks/mpn_plot_perf.py

all: $(BWORK) mpn_benchmark

$(BWORK):
	mkdir -p $(BWORK)

clean:
	rm -rf $(BWORK)

mpn_benchmark: $(MPN_OUTPUT) $(MPN_PLOT)

$(MPN_OUTPUT) :
	$(VERILATOR_SIM) +q +TIMEOUT=4000000 \
        +PASS_ADDR=0xC000001C +FAIL_ADDR=0xC0000010 \
        +IMEM=/home/ben/scarv/repos/hw-crypto-cop/work/examples/mpn.srec \
        > $@

$(MPN_PLOT) : $(MPN_OUTPUT)
	cat $(MPN_OUTPUT) $(MPN_PROCESS) | python
	mv plot*.svg $@
