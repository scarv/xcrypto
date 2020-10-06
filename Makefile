# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

ifndef REPO_HOME
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif
ifndef REPO_VERSION
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif

# =============================================================================

%-doc       :
	@make --directory="${REPO_HOME}/doc"           ${*}

%-docker    :
	@make --directory="${REPO_HOME}/src/docker"    ${*}

%-toolchain :
	@make --directory="${REPO_HOME}/src/toolchain" ${*}

# -----------------------------------------------------------------------------

doxygen  : ${REPO_HOME}/Doxyfile
	@doxygen ${<}

spotless :
	@rm --force --recursive ${REPO_HOME}/build/*

opcodes:
	cat $(REPO_HOME)/extern/riscv-opcodes/opcodes \
        $(REPO_HOME)/extern/riscv-opcodes/opcodes-xcrypto \
	| python3 $(REPO_HOME)/bin/parse_opcodes.py -check
	cat $(REPO_HOME)/extern/riscv-opcodes/opcodes-xcrypto \
	| python3 $(REPO_HOME)/bin/parse_opcodes.py -c > build/opcodes-xcrypto.h
	cat $(REPO_HOME)/extern/riscv-opcodes/opcodes-xcrypto \
	| python3 $(REPO_HOME)/extern/riscv-opcodes/parse-opcodes -verilog > build/opcodes-xcrypto.v

# =============================================================================
