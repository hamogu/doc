# -*- sh -*-
CONFIG=../config.inc
include ${CONFIG}

all: image_rgb.jpg m1_fit.png

source_flux.tbl: spectralmodel.py ../runciaotool.sh
	../runciaotool.sh sherpa -b spectralmodel.py
diffuse_evt2.fits: ${CONFIG} source_flux.tbl run_marx.sh runmarx.inc runmarx2fits.inc runmarxasp.inc
	./run_marx.sh
acis7sbkg.fits: copycaldbbkg.sh
	../runciaotool.sh ./copycaldbbkg.sh
merged.fits: acis7sbkg.fits diffuse_evt2.fits
	./mergebkg.sh
bkg.eps bkg.png: diffuse_evt2.fits merged.fits merged.fits ../runciaotool.sh
	../runciaotool.sh ds9 -geometry 800x500 -log -cmap heat -zoom 0.25 diffuse_evt2.fits merged.fits merged.fits -bin filter "energy > 200 & energy < 2000" -tile column -saveimage $@ -exit

letgplaw_pha2.fits: ${CONFIG} letgplaw_evt2.fits letgplaw_ciao.sh ../runciaotool.sh
	../runciaotool.sh ./letgplaw_ciao.sh
image_rgb.jpg: rgb.sh letgplaw_evt2.fits
	../runciaotool.sh ./rgb.sh
m1_fit.png: ../runciaotool.sh sherpafit.py letgplaw_pha2.fits
	../runciaotool.sh sherpa -b sherpafit.py
#
#
#
clean:
	/bin/rm -f *~ */*~
distclean: clean
	/bin/rm -rf *.tbl *.fits *.par source_flux.tbl image_rgb.* \
	  diffuse m1_fit.png m1_fit.eps
#
.PHONY: all clean distclean

