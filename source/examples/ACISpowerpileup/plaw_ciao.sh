#!/bin/sh
# This file is included in the html documents, in three chunks, separated by line
# numbers. After editing this file, check that the line numbers are still correct.

# Extraction region parameters: circle of radius R at (X,Y)
X=4096.5
Y=4096.5
R=20.0;

phagrid="pi=1:1024:1"

evtfile="plaw_evt2.fits"
asolfile="plaw_asol1.fits"
phafile="plaw_pha.fits"
rmffile="plaw_rmf.fits"
arffile="plaw_arf.fits"
asphistfile="plaw_asp.fits"

asphist infile="$asolfile" outfile="$asphistfile" evtfile="$evtfile" \
  verbose=1 mode=h clobber=yes

dmextract infile="$evtfile[sky=Circle($X,$Y,$R)][bin $phagrid]" \
  outfile="$phafile" verbose=1 mode=h clobber=yes

# Select a CCD.
ccdid=7;

detname="ACIS-$ccdid;UNIFORM;bpmask=0"
grating="NONE"
# For ACIS-I, use engrid="0.3:11.0:0.003". This reflects a limitation of mkrmf.
engrid="0.3:12.0:0.003"

mkarf mirror="hrma" detsubsys="$detname" grating="$grating" \
  outfile="$arffile" \
  obsfile="$evtfile" engrid="$engrid" asphistfile="$asphistfile" \
  sourcepixelx=$X sourcepixely=$Y \
  maskfile=NONE pbkfile=NONE dafile=NONE \
  verbose=1 mode=h clobber=yes

# Mean chip position
chipx=221;
chipy=532;

fef="$CALDB/data/chandra/acis/fef_pha/acisD2000-01-29fef_phaN0005.fits"

cxfilter="chipx_hi>=$chipx,chipx_lo<=$chipx"
cyfilter="chipy_hi>=$chipy,chipy_lo<=$chipy"
mkrmf infile="$fef[ccd_id=$ccdid,$cxfilter,$cyfilter]" \
  outfile="$rmffile" axis1="energy=$engrid" \
  axis2="$phagrid" thresh=1e-8 mode=h clobber=yes verbose=1
