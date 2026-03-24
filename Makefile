MAIN = main
LATEX = pdflatex
BIBTEX = bibtex
LATEX_FLAGS = -interaction=nonstopmode -halt-on-error

.PHONY: all clean watch

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex refs.bib opoch.sty sections/*.tex appendices/*.tex figures/*.tex
	$(LATEX) $(LATEX_FLAGS) $(MAIN)
	$(BIBTEX) $(MAIN)
	$(LATEX) $(LATEX_FLAGS) $(MAIN)
	$(LATEX) $(LATEX_FLAGS) $(MAIN)

quick:
	$(LATEX) $(LATEX_FLAGS) $(MAIN)

clean:
	rm -f $(MAIN).{aux,bbl,blg,log,out,pdf,synctex.gz,toc,lof,lot,fdb_latexmk,fls}
	rm -f sections/*.aux appendices/*.aux

watch:
	@echo "Watching for changes..."
	@fswatch -o $(MAIN).tex sections/*.tex appendices/*.tex figures/*.tex | xargs -n1 -I{} make quick
