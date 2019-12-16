BUILD = ${REPO_HOME}/build/spec

REPO_DIRTY =$(shell git diff)

include ${REPO_HOME}/extern/texmf/make/image.mk

${BUILD}/spec.version :
	@echo ${REPO_VERSION} > ${@}

.PHONY: ${BUILD}/spec.commit
${BUILD}/spec.commit:
	@git rev-parse --abbrev-ref HEAD > ${@}
	@echo "@" >> ${@}
	@git log --pretty=format:'%H' -n 1 >> ${@}
ifneq ("$(REPO_DIRTY)","")
	@echo "{\\\color{red}\\\bf -dirty}" >> ${@} ;
endif

${BUILD}/spec.ise     : ${REPO_HOME}/extern/riscv-opcodes/opcodes-xcrypto
	@cat ${^} | python3 ${REPO_HOME}/extern/riscv-opcodes/parse-opcodes -xcrypto-tex > ${@}

${BUILD}/spec.pdf     : ./spec.tex $(wildcard ./tex/*) ${IMAGE_TARGETS} ${BUILD}/spec.version ${BUILD}/spec.ise ${BUILD}/spec.commit
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" biber    --output_directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" biber    --output_directory $(dir ${@}) $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory $(dir ${@}) $(basename ${<})

dir   :
	@mkdir --parents ${BUILD}
	@mkdir --parents ${BUILD}/image

all   : dir ${BUILD}/spec.pdf

clean :
	@rm -rf ${BUILD}
