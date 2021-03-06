PDFLATEX = for n in 1 2 3; do pdflatex $<; done
XSLTPROC = xsltproc
INKSCAPE = inkscape

SCHEMA_DIR = $(CURDIR)/files

XSLT_FILES =       \
	binary.tex     \
	hardware.tex   \
	kernel.tex     \
	scheduling.tex \
	subject.tex    \
	types.tex

LARGE_GRAPHS = subject_type

COMMON_SOURCES =  \
	tikzstyle.tex \
	graph_*.tex   \
	lst_*.tex     \
	images/*      \
	files/*

REPORT_SOURCES =        \
	report.tex          \
	report.bib          \
	abstract.tex        \
	acknowledgments.tex \
	introduction.tex    \
	background.tex      \
	back_*.tex          \
	design.tex          \
	des_*.tex           \
	implementation.tex  \
	impl_*.tex          \
	analysis.tex        \
	conclusion.tex      \
	concl_*.tex         \
	$(COMMON_SOURCES)

SLIDES_SOURCES =      \
	slides.tex        \
	$(COMMON_SOURCES)

UML_TARGETS = $(patsubst %.svg,%.pdf,$(wildcard images/xml_*.svg))

all: report.pdf slides.pdf

%.pdf: %.svg
	$(INKSCAPE) --file=$< --export-area-drawing --without-gui --export-pdf=$@

report.pdf: $(REPORT_SOURCES) $(XSLT_FILES) $(UML_TARGETS)
	@pdflatex $<
	@makeindex report
	@bibtex report
	@pdflatex $<
	@pdflatex $<

slides.pdf: $(SLIDES_SOURCES)
	@$(PDFLATEX)

%.tex: $(SCHEMA_DIR)/%.xsd xsl/xsd2tex-types.xsl
	$(XSLTPROC) --stringparam SCHEMADIR $(SCHEMA_DIR) --stringparam LARGEGRAPHS $(LARGE_GRAPHS) \
		-o $@ xsl/xsd2tex-types.xsl $<

clean:
	@rm -f *.pdf *.aux *.lof *.log *.toc *.snm *.out *.nav *.vrb *.bbl *.blg *.lol *.lot
	@rm -f *.idx *.ilg *.ind
	@rm -f $(XSLT_FILES)
