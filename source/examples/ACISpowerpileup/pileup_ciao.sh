#!/bin/sh

X=4096.5
Y=4096.5
R=4.0;
phagrid="pi=1:1024:1"

evtfile="plaw_pileup_evt2.fits"
phafile="plaw_pileup_pha.fits"

dmextract infile="$evtfile[sky=Circle($X,$Y,$R)][bin $phagrid]" \
  outfile="$phafile" mode=h clobber=yes verbose=0
