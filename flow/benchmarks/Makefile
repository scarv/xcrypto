
BWORK       = $(XC_HOME)/work/benchmarks

MPN_OUTPUT  = $(BWORK)/mpn-data-$(LIBSCARV_ARCH).py
MPN_PROCESS = $(XC_HOME)/flow/benchmarks/mpn_plot_perf.py

all: $(BWORK) mpn_benchmark

$(BWORK):
	mkdir -p $(BWORK)

clean:
	rm -rf $(BWORK)


$(MPN_OUTPUT) :
	$(VERILATOR_SIM) +q +TIMEOUT=4000000 \
        +PASS_ADDR=0xC000001C +FAIL_ADDR=0xC0000010 \
        +IMEM=/home/ben/scarv/repos/hw-crypto-cop/work/examples/mpn.srec \
        > $@

mpn_benchmark : $(MPN_OUTPUT)
	echo "arch    = '${LIBSCARV_ARCH}'" >  ${BWORK}/build-info
	echo "out_dir = '${BWORK}'" >> ${BWORK}/build-info
	cat $(MPN_OUTPUT) ${BWORK}/build-info $(MPN_PROCESS) | python
