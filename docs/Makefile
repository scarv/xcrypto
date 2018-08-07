SOURCES = crypto-ise.tex
TARGETS = $(patsubst %.tex, %.pdf, ${SOURCES})

${TARGETS} : %.pdf : %.tex
	@pdflatex ${*}.tex
	@biber    ${*}
	@pdflatex ${*}.tex
	@biber    ${*}
	@pdflatex ${*}.tex

all      : ${TARGETS}

clean    :
	@rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.pdf *.version *.xml *.toc \
        *.bak

spotless : clean
	@rm -f *.pdf 
