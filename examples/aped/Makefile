# -*- sh -*-
CONFIG=../config/config.inc
include ${CONFIG}

all: aped_evt2.fits apedflux.png apedmeg1.png MEG_drywet_osort.png
# apedfit.png

apedflux.tbl: aped.p apedfun.sl
	$(MARXFLUX) -s apedfun.sl -l '[1:30:#16384]' aped.p apedflux.tbl
aped_evt2.fits: apedflux.tbl run_marx.sh
	sh ./run_marx.sh
aped_pha2.fits: aped_evt2.fits aped_ciao.sh
	runciaotool.sh ./aped_ciao.sh
apedmeg1.ps: aped_pha2.fits isismeg1.sl
	isis ./isismeg1.sl
apedmeg1.png: apedmeg1.ps
	ps2png apedmeg1
apedflux.png: apedflux.tbl makeplots.sl
	slsh ./makeplots.sl
MEG_drywet_osort.png: aped_pha2.fits
	/aluche/d3/sci/scripts/osortimg aped_evt1a.fits osort.png
clean:
	/bin/rm -f *~
distclean: clean
	/bin/rm -f *.ps *.png *.fig aped_*.fits apedflux.tbl
	/bin/rm -rf aped

