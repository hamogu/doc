#!/bin/sh

# Extraction region parameters: circle of radius R at (X,Y)
X=4096.5
Y=4096.5
R=20.0;

# Mean chip position
chipx=221;
chipy=532;
ccdid=7;

Verbose=1

detname="ACIS-$ccdid;UNIFORM;bpmask=0"

grating="NONE"
engrid="0.3:12.0:0.003"
phagrid="pi=1:1024:1"
# For ACIS-I, use engrid="0.3:11.0:0.003". This reflects a limitation
# of mkrmf.

evtfile="plaw_evt2.fits"
asolfile="plaw_asol1.fits"
phafile="plaw_pha.fits"
rmffile="plaw_rmf.fits"
arffile="plaw_arf.fits"
asphistfile="plaw_asp.fits"

obsfile="$evtfile"

echo Running asphist
asphist infile="$asolfile" outfile="$asphistfile" evtfile="$evtfile" \
  verbose=$Verbose mode=h clobber=yes

echo Running mkarf
mkarf mirror="hrma" detsubsys="$detname" grating="$grating" \
  outfile="$arffile" \
  obsfile="$obsfile" engrid="$engrid" asphistfile="$asphistfile" \
  sourcepixelx=$X sourcepixely=$Y \
  maskfile=NONE pbkfile=NONE dafile=NONE verbose=$Verbose mode=h clobber=yes

echo Running dmextract
dmextract infile="$evtfile[sky=Circle($X,$Y,$R)][bin $phagrid]" \
  outfile="$phafile" verbose=$Verbose mode=h clobber=yes

echo Running mkrmf
# The file layout of CALDB 4.1 has changed.  The FEF used to located using:
#   fef="$CALDB/data/chandra/acis/cpf/fefs/acisD2000-01-29fef_phaN0005.fits"
# However, in CIAO 4.1 the location is given as:
fef="$CALDB/data/chandra/acis/fef_pha/acisD2000-01-29fef_phaN0005.fits"

cxfilter="chipx_hi>=$chipx,chipx_lo<=$chipx"
cyfilter="chipy_hi>=$chipy,chipy_lo<=$chipy"
mkrmf infile="$fef[ccd_id=$ccdid,$cxfilter,$cyfilter]" \
  outfile="$rmffile" axis1="energy=$engrid" \
  axis2="$phagrid" thresh=1e-8 mode=h clobber=yes verbose=$Verbose
