##### Variables #############
#Un seul fichier tex ne doit etre present dans le dossier

#sources
SRC= $(wildcard *.tex)
INCDIR=content/
INCLUDES=$(wildcard $(INCDIR)*.tex)
#contient les fichiers de type eps
EPSSDIR=epss/
#contient les fichiers de type jpg et png
IMGSDIR=figures/
PNGS=$(wildcard $(IMGSDIR)*.png)
JPGS=$(wildcard $(IMGSDIR)*.jpg)
#contient les fichiers de type svg et fig
FIGSDIR=figures/
SVGS=$(wildcard $(FIGSDIR)*.svg)
FIGS=$(wildcard $(FIGSDIR)*.fig)

# fichiers generes
DVI= $(SRC:.tex=.dvi)
PS= $(SRC:.tex=.ps)
PDF= $(SRC:.tex=.pdf)
AUX= $(SRC:.tex=.aux)
LOG= $(SRC:.tex=.log)
BBL= $(SRC:.tex=.bbl)
BLG= $(SRC:.tex=.blg)
TOC= $(SRC:.tex=.toc)
OUT= $(SRC:.tex=.out)
FLS= *.fls
FDB= *.fdb_latexmk
LOF= *.lof



#images generes
PNGS2EPSS=$(subst $(IMGSDIR), $(EPSSDIR), $(PNGS:.png=.eps))
JPGS2EPSS=$(subst $(IMGSDIR), $(EPSSDIR), $(JPGS:.jpg=.eps))
SVGS2EPSS=$(subst $(FIGSDIR), $(EPSSDIR), $(SVGS:.svg=.eps))
FIGS2EPSS=$(subst $(FIGSDIR), $(EPSSDIR), $(FIGS:.fig=.eps))
IMAGES=$(PNGS2EPSS) $(JPGS2EPSS) $(SVGS2EPSS) $(FIGS2EPSS)
#commandes
RM = rm -rf
PS2PDF = ps2pdf
DVIPS = dvips -o
LATEX = pdflatex
MKDIR = mkdir -p
TOUCH = touch
##### Cibles ###############

pdf : $(PDF)

#pour la cible pdf on doit avoir genere un pdf
$(PDF): $(PS)
	$(PS2PDF) $<

ps : $(PS)

#pour la cible ps on doit avoir genere un ps
$(PS): $(DVI)
	$(DVIPS) $@ $<

dvi : $(DVI)

#pour la cible dvi on doit avoir genere les images et un dvi
$(DVI) : $(SRC) $(INCLUDES) $(IMAGES)
	$(LATEX) $<
	$(LATEX) $<


#la cible figure genere les images en eps
figures : $(IMAGES)

#generation des images en eps depuis les png
$(EPSSDIR)%.eps : $(IMGSDIR)%.png
	convert $< EPS:$@

#generation des images en eps depuis les jpg
$(EPSSDIR)%.eps : $(IMGSDIR)%.jpg
	convert $< EPS:$@

#generation des images en eps depuis les svg
$(EPSSDIR)%.eps : $(FIGSDIR)%.svg
	inkscape -E $@ $<

#generation des images en eps depuis les fig
$(EPSSDIR)%.eps : $(FIGSDIR)%.fig
	fig2dev -L eps $< > $@

#generation des repertoires au debut du projet
dir :
	$(MKDIR) $(EPSSDIR) $(IMGSDIR) $(FIGSDIR) $(INCDIR)

#Pour clean, on supprime tous les fichiers generes sauf le pdf
.PHONY:clean
clean:
	$(RM) -rf \#* *~ $(DVI) $(PS) $(AUX) $(LOG) $(BBL) $(BLG) $(OUT) $(TOC)
	$(RM) $(PNGS2EPSS) $(JPGS2EPSS) $(SVGS2EPSS) $(FIGS2EPSS)

#Pour very-clean, on supprime tous les fichiers generes
.PHONY:very-clean
very-clean : clean
	$(RM) -rf $(PDF) $(FLS) $(PDB) $(LOF)
