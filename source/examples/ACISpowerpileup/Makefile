# -*- sh -*-
CONFIG=../config.inc
include ${CONFIG}

all: plawfit.png plawpileupfit.png plaw_evt2.fits

# convert pictures
%.png: %.ps
	convert -rotate 90 $< $@
#
# run first part of example
#
run_marx.sh: ${CONFIG} runmarx.inc runmarx2fits.inc runmarxasp.inc
	touch ./run_marx.sh
plaw_evt2.fits: ${CONFIG} plawflux.tbl run_marx.sh
	./run_marx.sh
plaw.p: ${CONFIG}
	$(ISISSCRIPT) ./isismodel.sl
plawflux.tbl: ${CONFIG} plaw.p
	./run_marxflux.sh
plaw_pha.fits: ${CONFIG} plaw_evt2.fits plaw_ciao.sh runciaotool.sh
	./runciaotool.sh ./plaw_ciao.sh
plawfit.ps: plaw_pha.fits isisfit.sl
	$(ISISSCRIPT) ./isisfit.sl
#
# Pileup
#
run_marxpileup.sh: runmarxpileup.inc runmarx2fitspileup.inc
	touch ./run_marxpileup.sh
plaw_pileup_evt2.fits: run_marxpileup.sh plaw/energy.dat
	./run_marxpileup.sh
plaw_pileup_pha.fits: pileup_ciao.sh plaw_pileup_evt2.fits
	./runciaotool.sh ./pileup_ciao.sh
isispileup.sl: isispileup*.inc
	touch isispileup.sl
plawpileupfit.ps: plaw_pileup_pha.fits isispileup.sl
	$(ISISSCRIPT) ./isispileup.sl
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
	  plaw_rmf.fits marxasp.par marx.par marxpileup.par fit_search* plaw.p
#
.PHONY: all
