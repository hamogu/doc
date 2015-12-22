CONFIG=../config.inc
include ${CONFIG}

all: obs1068_chandra.png

%.par:
	cp ${MARXPREFIX}/share/marx/pfiles/$@ .

1068/primary/acisf01068N003_evt2.fits.gz: ../runciaotool.sh
	../runciaotool.sh download_chandra_obsid 1068
1068/repro/acisf01068_repro_evt2.fits: 1068/primary/acisf01068N003_evt2.fits.gz
	../runciaotool.sh chandra_repro 1068 1068/repro

obs1068_chandra.png obs1068_chandra.eps: 1068/repro/acisf01068_repro_evt2.fits
	../runciaotool.sh ds9 -width 800 -height 500 -log -cmap heat $< -crosshair 5256 6890 physical -pan to 5256 6890 physical -bin about 5256 6890 -saveimage $@ -exit


obs1068.arf: 1068/repro/acisf01068_repro_evt2.fits runmkarf.sh ../runciaotool.sh
	../runciaotool.sh ./runmkarf.sh

obs1068.spec: 1068/repro/acisf01068_repro_evt2.fits extract.sh ../runciaotool.sh
	../runciaotool.sh ./extract.sh

input_spec_marx.tbl: obs1068.arf obs1068.spec spectrum2ascii.sh ../runciaotool.sh
	../runciaotool.sh ./spectrum2ascii.sh

marx_only.fits: marxonly.sh 1068/repro/acisf01068_repro_evt2.fits ../runmarxtool.sh input_spec_marx.tbl marx.par
	../runmarxtool.sh ./$<

clean:
	/bin/rm -f *~ */*~
distclean: clean
	/bin/rm -rf *.tbl *.fits *.par 1068 *.png *.eps *.jpg \
	marx_only

.PHONY: all clean distclean

