ETABLE  = $(COP_WORK)/crypto-ise.encodings.tex
SOURCES = crypto-ise.tex
TARGETS = $(patsubst %.tex, %.pdf, ${SOURCES})

${TARGETS} : $(ETABLE)
${TARGETS} : %.pdf : %.tex
	@pdflatex ${*}.tex
	@biber    ${*}
	@pdflatex ${*}.tex
	@biber    ${*}
	@pdflatex ${*}.tex

all      : ${TARGETS} $(ETABLE)

$(ETABLE): ise-opcodes.txt
	cat $< | $(COP_HOME)/bin/ise-parse-opcodes.py -tex > $@

clean    :
	@rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.pdf *.version *.xml *.toc \
        *.bak

spotless : clean
	@rm -f *.pdf 
