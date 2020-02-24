# Copyright (C) 2019 SCARV project <info@scarv.org>
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

BUILD = ${REPO_HOME}/build/doc

${BUILD}/spec.version :
	@echo ${REPO_VERSION} > ${@}

${BUILD}/spec.commit  :
	@git rev-parse --abbrev-ref HEAD                                                      > ${@}
	@echo '@'                                                                            >> ${@}
	@git log --pretty=format:'%H' --max-count 1                                          >> ${@}
	@if [[ $(shell git diff | wc --lines) -ne 0 ]] ; then echo '{\color{red}\bf -dirty}' >> ${@} ; fi

${BUILD}/spec.ise     : ${REPO_HOME}/extern/riscv-opcodes/opcodes-xcrypto
	@cat ${^} | python3 ${REPO_HOME}/extern/riscv-opcodes/parse-opcodes -xcrypto-tex > ${@}

include ${REPO_HOME}/extern/texmf/make/image.mk

${BUILD}/spec.pdf     : ./spec.tex $(wildcard ./tex/*) ${IMAGE_TARGETS} ${BUILD}/spec.version ${BUILD}/spec.commit ${BUILD}/spec.ise
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" biber    --output_directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" biber    --output_directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory $(dir ${@}) $(basename ${<})

# =============================================================================

dir   :
	@mkdir --parents ${BUILD}
	@mkdir --parents ${BUILD}/image

build : dir ${BUILD}/spec.pdf

clean :
	@rm --force --recursive ${BUILD}

# =============================================================================
