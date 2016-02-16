dmcopy "1068/primary/acisf01068N003_evt2.fits.gz[EVENTS][bin x=4950:5530:1,y=6700:7100:1]" image.fits option=image clobber=yes
dmellipse image.fits psf90.reg 0.9 clobber=yes

# We have to use the same energy binning in energy space here that we used for the arf!
# So, first convert the PI to energy (to a precision that's good enough for this example.)
dmtcalc "1068/repro/acisf01068_repro_evt2.fits[EVENTS][sky=region(psf90.reg)]" obs1068_evt2_with_energy.fits  expr="energy=(float)pi*0.0149" clobber=yes
dmextract "obs1068_evt2_with_energy.fits[bin energy=.3:7.999:0.1]" obs1068.spec clobber=yes opt=generic
