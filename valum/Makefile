DOCUMENTS := presentation.pdf enonce.pdf

all: $(DOCUMENTS)

enonce.pdf: enonce.md
	pandoc $< -o $@

presentation.pdf: presentation.md
	pandoc -t beamer -V theme:Rochester --latex-engine xelatex -o $@ $<

clean:
	rm $(DOCUMENTS)
