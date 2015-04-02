FIGURES = schematic_pileup evt_grid


BUILDFIGDIR = ../../figures/
FIG_TYPE = pdf png eps
ALL_TYPES = $(foreach figtype, $(FIG_TYPE), $(BUILDFIGDIR)/$(figname).$(figtype))
ALL = $(foreach figname, $(FIGURES), $(ALL_TYPES))

all: $(ALL)

$(BUILDFIGDIR)/%.ps $(BUILDFIGDIR)/%.pdf $(BUILDFIGDIR)/%.png: %.py
	python $< $(BUILDFIGDIR)/$* 


clean:
	-rm $(ALL)

.PHONY: all clean