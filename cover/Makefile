.PHONY: default all clean out-dir version.tex scala ocaml reason

DIR := $(shell pwd)
GIT_VER := $(shell git describe --tags --always --long | tr -d '\n')
OUTPUT_DIR := ../out/$(GIT_VER)

OUTPUT = m3y-cover

COVERTOPTEX = cover.tex
COVERPDF:=$(COVERTOPTEX:.tex=.pdf)

default: cover

all: clean default

# Main targets
cover:
	if which latexmk > /dev/null 2>&1 ;\
	then \
		latexmk \
			-shell-escape \
			-interaction=nonstopmode \
			-halt-on-error \
			-norc \
			-jobname=m3y-cover \
			-outdir=$(OUTPUT_DIR) \
			-pdflatex="xelatex %O %S" \
			-pdf cover.tex; \
	else @printf "Error: unable to find latexmk. Is it installed?\n" ;\
	fi

version.tex:
	@printf '\\newcommand{\\OPTversion}{' > version.tex
	@printf $(GIT_VER) >> version.tex
	@printf '}' >> version.tex
