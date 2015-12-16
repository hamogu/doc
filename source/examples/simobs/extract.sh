dmcopy "1068/primary/acisf01068N003_evt2.fits.gz[EVENTS][bin x=4950:5530:1,y=6700:7100:1]" image.fits option=image clobber=yes
dmellipse image.fits psf90.reg 0.9 clobber=yes

# We have to use the same energy binning in PI space here that we used for the arf!
# (Except that the PI is in eV, not keV.)
dmextract "1068/primary/acisf01068N003_evt2.fits.gz[EVENTS][sky=region(psf90.reg)][bin pi=300:7999:100]" obs1068.pi clobber=yes
