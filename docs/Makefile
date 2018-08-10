SOURCES = crypto-ise.tex ise-implementation.tex
TARGETS = $(patsubst %.tex, %.pdf, ${SOURCES})

${TARGETS} : %.pdf : %.tex
	@pdflatex ${*}.tex
	@biber    ${*}
	@pdflatex ${*}.tex
	@biber    ${*}
	@pdflatex ${*}.tex

all      : ${TARGETS}

ise-spec : crypto-ise.pdf
impl-spec: ise-implementation.pdf

clean    :
	@rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.pdf *.version *.xml *.toc \
        *.bak

spotless : clean
	@rm -f *.pdf 
