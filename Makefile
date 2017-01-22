NAME=slides
OUTPUT_DIR=output
DIAGRAM_OUT_DIR=${OUTPUT_DIR}/diagrams

all: pvc-force

SEQ_FILES := $(wildcard diagrams/*.seqdiag)
DIAGRAM_FILES := $(addprefix ${DIAGRAM_OUT_DIR}/,$(notdir $(SEQ_FILES:.seqdiag=.pdf)))

SEQ_FILES := $(wildcard diagrams/*.blockdiag)
DIAGRAM_FILES += $(addprefix ${DIAGRAM_OUT_DIR}/,$(notdir $(SEQ_FILES:.blockdiag=.pdf)))

NW_FILES := $(wildcard diagrams/*.nwdiag)
DIAGRAM_FILES += $(addprefix ${DIAGRAM_OUT_DIR}/,$(notdir $(NW_FILES:.nwdiag=.pdf)))

CONFUSION_FILES := $(wildcard diagrams/*.tex)
DIAGRAM_FILES += $(addprefix ${DIAGRAM_OUT_DIR}/,$(notdir $(CONFUSION_FILES:.tex=.pdf)))

${DIAGRAM_OUT_DIR}/%.pdf: diagrams/%.tex
	@mkdir -p ${DIAGRAM_OUT_DIR}
	cat $< | lualatex -jobname $(@D)/$(*F)
	#pdftoppm -r 600 -png $@ > $(@D)/$(*F).png

${DIAGRAM_OUT_DIR}/%.pdf: diagrams/%.seqdiag
	@mkdir -p ${DIAGRAM_OUT_DIR}
	seqdiag -o $@ -Tpdf $<

${DIAGRAM_OUT_DIR}/%.pdf: diagrams/%.blockdiag
	@mkdir -p ${DIAGRAM_OUT_DIR}
	blockdiag -o $@ -Tpdf $<

${DIAGRAM_OUT_DIR}/%.pdf: diagrams/%.nwdiag
	@mkdir -p ${DIAGRAM_OUT_DIR}
	nwdiag -o $@ -Tpdf $<

output_dir:
	mkdir -p $(OUTPUT_DIR)/output/

report.pdf: $(DIAGRAM_FILES) output_dir *.tex
	latexmk -outdir=$(OUTPUT_DIR) -auxdir=$(OUTPUT_DIR) -latexoption="--shell-escape" -lualatex -pdf $(NAME).tex

pvc-force: $(DIAGRAM_FILES) output_dir *.tex
	latexmk -outdir=$(OUTPUT_DIR) -auxdir=$(OUTPUT_DIR) -latexoption="--shell-escape" -lualatex -pdf --pvc --synctex=1 -f $(NAME).tex

clean:
	rm -rf $(OUTPUT_DIR)
