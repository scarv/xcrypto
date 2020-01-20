ifndef REPO_HOME
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif

.PHONY: doc

doc       :
	@${MAKE} -C ${REPO_HOME}/doc all

doc-clean : 
	@${MAKE} -C ${REPO_HOME}/doc clean

all      : doc

clean    : doc-clean

spotless :
	@rm -rf ${REPO_HOME}/build/*

opcodes:
	cat $(REPO_HOME)/extern/riscv-opcodes/opcodes \
        $(REPO_HOME)/extern/riscv-opcodes/opcodes-xcrypto \
        $(REPO_HOME)/tools/opcodes-maskingise \
	| python3 $(REPO_HOME)/bin/parse_opcodes.py -c > build/opcodes-all.h
	cat $(REPO_HOME)/extern/riscv-opcodes/opcodes-xcrypto \
        $(REPO_HOME)/tools/opcodes-maskingise \
	| python3 $(REPO_HOME)/bin/parse_opcodes.py -c > build/opcodes-xcrypto.h
