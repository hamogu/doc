# -*- sh -*-
CONFIG=../config.inc
include ${CONFIG}

all: bkg.png bkg2.png chip-shape.png carina.jpg

carina.jpg:
	wget http://chandra.harvard.edu/photo/2011/carina/carina.jpg

carina.eps: carina.jpg
	convert $< $@

source_flux.tbl: spectralmodel.py ../runciaotool.sh
	../runciaotool.sh sherpa -b spectralmodel.py
diffuse_evt2.fits: ${CONFIG} source_flux.tbl run_marx.sh runmarx.inc runmarx2fits.inc runmarxasp.inc
	./run_marx.sh
acis7sbkg.fits: copycaldbbkg.sh
	../runciaotool.sh ./copycaldbbkg.sh
merged.fits: acis7sbkg.fits diffuse_evt2.fits
	../runciaotool.sh ./mergebkg.sh
bkg.eps bkg.png: diffuse_evt2.fits merged.fits ../runciaotool.sh
	../runciaotool.sh ds9 -geometry 800x500 -log -cmap heat -zoom 0.25 diffuse_evt2.fits merged.fits merged.fits -bin filter "energy > 200 & energy < 2000" -tile column -saveimage $@ -exit

# the rule for "merged.fits" also produces diffuse_asol1.fits and acis7s_bkg_reproj.fits
# which are the files we really need here.
blank_sky.rmf : merged.fits ../runciaotool.sh
	../runciaotool.sh  ./extract_blanksky.sh

bkgspec.tbl : blank_sky.py blank_sky.rmf ../runciaotool.sh
	../runciaotool.sh sherpa -b $<

chip-shape.fits: dmcopy.sh merged.fits
	../runciaotool.sh ./dmcopy.sh

chip-shape.jpg chip-shape.eps: chip-shape.fits	../runciaotool.sh
	../runciaotool.sh ds9 -geometry 500x600 -cmap heat chip-shape.fits -zoom 8 -crop 4300 3750 1600 5000 -saveimage $@ -exit

bkg/xpos.dat: marx4bkg.sh chip-shape.fits ../runmarxtool.sh bkgspec.tbl
	../runmarxtool.sh ./marx4bkg.sh

diffuse_with_bkg.fits: run_marx.sh runmarx.inc bkg/xpos.dat diffuse_evt2.fits
	../runmarxtool.sh ./marxcat.sh

bkg2.eps bkg2.png: diffuse_evt2.fits diffuse_with_bkg.fits ../runciaotool.sh
	../runciaotool.sh ds9 -geometry 800x500 -log -cmap heat -zoom 0.25 diffuse_evt2.fits diffuse_with_bkg.fits diffuse_with_bkg.fits -bin filter "energy > 200 & energy < 2000" -tile column -saveimage $@ -exit


#
#
#
clean:
	/bin/rm -f *~ */*~
distclean: clean
	/bin/rm -rf *.tbl *.fits *.par diffuse bkg *.png *.eps *jpg \
	blank_sky.asphist blank_sky.pi blank_sky.wfef blank_sky.arf blank_sky.rmf
#
.PHONY: all clean distclean

