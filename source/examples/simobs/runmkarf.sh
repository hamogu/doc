#!/bin/sh

X=5256
Y=6890

evtfile="1068/repro/acisf01068_repro_evt2.fits"
asolfile="1068/repro/pcadf051708271N003_asol1.fits"
aspfile="obs1068.asp"
arffile="obs1068.arf"

asphist infile="$asolfile" outfile="$aspfile" evtfile="$evtfile" clobber=yes

# It would be more accuarte to use mkwarf.
# However, that's slower and for our purposes an approximate solution is good enough.
mkarf detsubsys="ACIS-S0" grating="NONE" outfile="$arffile" \
  obsfile="$evtfile" asphistfile="$aspfile" \
  sourcepixelx=$X sourcepixely=$Y engrid="0.3:8.0:0.1" \
  maskfile=NONE pbkfile=NONE dafile=NONE \
  verbose=1 mode=h clobber=yes 
