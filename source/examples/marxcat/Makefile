# -*- sh -*-
# This Makefile is a little messed up.
# In a Makefile, every target has one rule and every rule makes one target.
# However, in the example text, we include the .inc files, many of which
# make multiple targets (e.g. runmarx.inc makes both EQPegA and EQPegB).
# Thus this Makefile does not reflect all dependencies accurately.
# It is sufficient to build the exmaple, but many important files are 
# generated in the process, that are not explicetly mentioned here.
# The goal here is to make .inc files that can be presented to the user in 
# the html page as a locigal text. I want to use the same files here to
# avoid regessions and the parice I pay is this oddly incomplete Makefile.

CONFIG=../config.inc
include ${CONFIG}

all: eqpeg_spectra.png eqpeg_image.jpg

EQPegB_flux.tbl: spectralmodel.py ../runciaotool.sh
	../runciaotool.sh sherpa -b spectralmodel.py

%.par:
	cp ${MARXPREFIX}/share/marx/pfiles/$@ .

EQPegB/energy.dat: ${CONFIG} EQPegB_flux.tbl runmarx.inc marx.par ../runmarxtool.sh 
	../runmarxtool.sh ./runmarx.inc

EQPeg_both/energy.dat: EQPegB/energy.dat ../runmarxtool.sh 
	../runmarxtool.sh ./runmarxcat.inc

EQPeg_both.fits: runmarx2fits.inc EQPeg_both/energy.dat ../runmarxtool.sh 
	../runmarxtool.sh ./runmarx2fits.inc

EQPeg_asol1.fits : EQPeg_both.fits marxasp.par ../runmarxtool.sh 
	../runmarxtool.sh ./runmarxasp.inc

EQPegB_both_pha2.fits: ${CONFIG} EQPeg_both.fits EQPeg_asol1.fits eqpeg_ciao.sh ../runciaotool.sh
	../runciaotool.sh ./eqpeg_ciao.sh

eqpeg_spectra.png: eqpeg_sherpa.py EQPegB_both_pha2.fits ../runciaotool.sh
	../runciaotool.sh sherpa -b $<

eqpeg_image.jpg: rgb.sh EQPeg_both.fits EQPegB_both_pha2.fits
	../runciaotool.sh ./rgb.sh
#
#
#
clean:
	/bin/rm -f *~ */*~
distclean: clean
	/bin/rm -rf *.tbl *.fits *.par image_rgb.* \
	  EQPegA EQPegB *.png *.eps *.jpg
#
.PHONY: all clean distclean

