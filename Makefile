SLIDELEVEL=2

TARGETS=$(patsubst %.pandoc,%.pdf,$(wildcard *.pandoc)) $(patsubst %.pandoc,%-blog.txt,$(wildcard *.pandoc)) $(patsubst %.pandoc,%.epub,$(wildcard *.pandoc))

all: depend $(TARGETS)

depend: .depend

.depend: $(wildcard *.pandoc) makedep.sh
	rm -f .depend
	./makedep.sh > .depend

-include .depend

%.pdf: %.pandoc beamer.my beamercolorthemekrok.sty
	pandoc --slide-level $(SLIDELEVEL) -t beamer $< -H beamer.my -V theme:boxes -V fonttheme:structurebold -V classoption:aspectratio=169 --latex-engine=pdflatex -o $@

%.epub: %.pandoc beamer.my beamercolorthemekrok.sty
	pandoc --slide-level $(SLIDELEVEL) -t epub $< --template beamer.my -V theme:Warsaw -V fonttheme:structurebold -V colortheme:krok -o $@

%.png: img/%.png
	./mkimg.sh $@

%.jpg: img/%.jpg
	./mkimg.sh $@

%-blog.txt: %.pandoc
	php etxt.php $< > $@
clean:
	rm -f $(TARGETS) *.png *.jpg .depend

push:
	git push origin master
