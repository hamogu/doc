# -*- sh -*-
CONFIG=../config/config.inc
include ${CONFIG}

all: plawfit.png plawpileupfit.png plaw_evt2.fits

run_marx.sh: ${CONFIG} inc/runmarx.inc inc/runmarx2fits.inc inc/runmarxasp.inc
	touch ./run_marx.sh
plaw_evt2.fits: ${CONFIG} plawflux.tbl run_marx.sh
	./run_marx.sh
plawflux.tbl: ${CONFIG} plaw.p
	$(MARXFLUX) -e '[0.3:12.0:0.001]' plaw.p plawflux.tbl
#	./marxflux -e '[0.59:0.61:0.0001]' plaw.p plawflux.tbl
plaw_pha.fits: ${CONFIG} plaw_evt2.fits plaw_ciao.sh runciaotool.sh
	./runciaotool.sh ./plaw_ciao.sh
plawfit.ps: plaw_pha.fits isisfit.sl
	$(ISIS) ./isisfit.sl
plawfit.png: plawfit.ps
	ps2png plawfit
#
# Pileup
#
run_marxpileup.sh: inc/runmarxpileup.inc inc/runmarx2fitspileup.inc
	touch ./run_marxpileup.sh
plaw_pileup_evt2.fits: run_marxpileup.sh plaw/energy.dat
	./run_marxpileup.sh
plaw_pileup_pha.fits: pileup_ciao.sh plaw_pileup_evt2.fits
	./runciaotool.sh ./pileup_ciao.sh
isispileup.sl: inc/isispileup*.inc
	touch isispileup.sl
plawpileupfit.ps: plaw_pileup_pha.fits isispileup.sl
	$(ISIS) ./isispileup.sl
plawpileupfit.png: plawpileupfit.ps
	ps2png plawpileupfit
#
#
#
clean:
	/bin/rm -f *~ */*~
distclean: clean
	/bin/rm -rf plawpileupfit.png plawpileupfit.ps \
	  plawfit.png plawfit.ps plawflux.tbl plaw \
	  plaw_arf.fits plaw_asol1.fits plaw_asp.fits plaw_evt2.fits \
	  plaw_pha.fits plaw_pileup_evt2.fits plaw_pileup_pha.fits \
	  plaw_rmf.fits
#
.PHONY: all
