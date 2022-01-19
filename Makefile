.PHONY: default all clean out-dir version.tex scala ocaml reason

DIR := $(shell pwd)
GIT_VER := $(shell git describe --tags --always --long | tr -d '\n')
OUTPUT_DIR := ./out/$(GIT_VER)

OUTPUT = m3y

# Default top-level LaTeX to generate
DEFAULTTOPTEX = m3y-print.tex

EBOOKTEXFILES = m3y-ebook.tex

TOPTEXFILES = $(DEFAULTTOPTEX) $(EBOOKTEXFILES) #version.tex

# Default PDF file to make
DEFAULTPDF:=$(DEFAULTTOPTEX:.tex=.pdf)

EBOOKPDF:=$(EBOOKTEXFILES:.tex=.pdf)

# Other PDF files for the m3y book
TOPPDFFILES:=$(TOPTEXFILES:.tex=.pdf)

# Configuration files
OPTFILES = opt-print-blurb.tex \
		   opt-ebook.tex

TEXFILES = $(TOPTEXFILES) $(EBOOKTEXFILES) $(OPTFILES)

default: out-dir $(DEFAULTPDF) # todo cover

ebook: out-dir $(EBOOKPDF)

all: clean default

# Main targets
$(TOPPDFFILES) : %.pdf : %.tex $(TEXFILES)
	if which latexmk > /dev/null 2>&1 ;\
	then \
		latexmk \
			-shell-escape \
			-interaction=nonstopmode \
			-halt-on-error \
			-norc \
			-jobname=$(subst m3y,$(OUTPUT),$*) \
			-outdir=$(OUTPUT_DIR) \
			-pdflatex="xelatex %O %S" \
			-pdf $<; \
		ln -sf $(OUTPUT_DIR)/$(subst m3y,$(OUTPUT),$*).pdf $(OUTPUT_DIR)/$(OUTPUT).pdf ;\
	else @printf "Error: unable to find latexmk. Is it installed?\n" ;\
	fi

version.tex:
	@printf '\\newcommand{\\OPTversion}{' > version.tex
	@printf $(GIT_VER) >> version.tex
	@printf '}' >> version.tex

out-dir:
	@printf 'Creating output directory: $(OUTPUT_DIR)\n'
	mkdir -p $(OUTPUT_DIR)

clean:
	rm -f *.aux *.{out,log,pdf,dvi,fls,fdb_latexmk,aux,brf,bbl,idx,ilg,ind,toc,sed}
	if which latexmk > /dev/null 2>&1 ; then latexmk -CA; fi
	rm -r out/ >> /dev/null 2>&1 || true

clean-minted: 
	rm -rf _minted-*
