# -*- sh -*-
CONFIG=../config.inc
include ${CONFIG}

all: hetg.png hetg.eps hetgmeg1.ps hetgmeg1.png hetg_pldisk_pha2.fits hetg_plaw_pha2.fits hetg_plaw_reg1a.fits hetg_pldisk_reg1a.fits

# convert pictures
%.png: %.ps
	convert -rotate 90 $< $@
#
plaw_hetg.par: ${CONFIG}
	$(ISISSCRIPT) ./isismodel.sl
plawflux_hetg.tbl: ${CONFIG} plaw_hetg.par run_marxflux.inc
	./run_marxflux.sh
run_marx.sh: ${CONFIG} run_marx_point.inc run_marx_disk.inc  run_marx2fits.inc
	touch ./run_marx.sh
hetg_pldisk_evt2.fits: ${CONFIG} plawflux_hetg.tbl run_marx.sh
	./run_marx.sh
# made by the call directly above. Listed here so makes know what to do.
hetg_plaw_evt2.fits: hetg_pldisk_evt2.fits
	touch $@

# The following target makes several files (incl. arfs and rmfs).
# In principle, this should all be separate make rules, but in the context of this 
# example those files will always be generated together and having them run by a 
# single script (hetg_ciao.sh) allows for a better presentation in the documentation
# where this script is included.
%_pha2.fits: ${CONFIG} %_evt2.fits hetg_ciao.sh ../runciaotool.sh
	../runciaotool.sh ./hetg_ciao.sh $*
%_reg1a.fits: %_pha2.fits
	# This is made by the same script that generates hetg_pldisk_pha2.fits
	touch $@
hetg.eps hetg.png: hetg_plaw_evt2.fits hetg_plaw_reg1a.fits hetg_pldisk_evt2.fits hetg_pldisk_reg1a.fits
	ds9 -log -cmap heat hetg_plaw_evt2.fits -regions hetg_plaw_reg1a.fits -scale mode 99.9 hetg_pldisk_evt2.fits -regions hetg_pldisk_reg1a.fits -tile row -saveimage $@ -exit

hetgmeg1.ps: hetg_plaw_pha2.fits isisfit.sl hetg_plawMEG_-1_garf.fits hetg_plawMEG_1_garf.fits hetg_plawmeg-1_rmf.fits hetg_plawmeg1_rmf.fits
	$(ISISSCRIPT) ./isisfit.sl
#
#
#
#
clean:
	/bin/rm -f *~ */*~
distclean: clean
	/bin/rm -rf hetg_plaw hetg_pldisk *.png *.ps *.eps *.fits *.par plawflux_hetg.tbl
#
.PHONY: all clean distclean
