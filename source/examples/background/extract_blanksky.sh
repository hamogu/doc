dmextract infile="acis7s_bkg_reproj.fits[sky=rotbox(1:59:59,+39:59:20,3.2',3.5',0)][bin pi]" outfile='blank_sky.pi' wmap="[bin tdet=8]" clobber=yes

asphist infile=diffuse_asol1.fits outfile=blank_sky.asphist evtfile="diffuse_evt2.fits[ccd_id=7]" clobber=yes

sky2tdet infile="acis7s_bkg_reproj.fits[sky=rotbox(1:59:59,+39:59:20,3.2',3.5',0)][bin sky=8]" asphistfile="blank_sky.asphist" outfile="blank_sky_tdet.fits[wmap]" clobber=yes

mkwarf infile="blank_sky_tdet.fits[wmap]" outfile=blank_sky.arf weightfile=blank_sky.wfef egridspec=0.3:11.0:0.1  mskfile=NONE spectrumfile=NONE pbkfile=NONE clobber=yes

mkrmf infile=CALDB outfile=blank_sky.rmf axis1="energy=0:1" axis2="pi=1:1024:1" weights=blank_sky.wfef clobber=yes
