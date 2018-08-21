ETABLE  = $(COP_WORK)/crypto-ise.encodings.tex
SOURCES = crypto-ise.tex ise-implementation.tex
TARGETS = $(patsubst %.tex, %.pdf, ${SOURCES})

DIA_IN  = $(shell find -name "*.dot")
DIA_OUT = $(DIA_IN:%.dot=%.eps)


${TARGETS} : $(DIA_OUT)
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

diagrams: $(DIA_OUT)
diagrams/%.eps : diagrams/%.dot
	dot -Tps $< > $@

clean    :
	@rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.pdf *.version *.xml *.toc \
        *.bak

spotless : clean
	@rm -f *.pdf 
