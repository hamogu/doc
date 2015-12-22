dmcopy "obs1068.arf[cols energ_lo,energ_hi,specresp]" input_spec.fits clobber=yes
dmpaste input_spec.fits "obs1068.spec[cols counts]" input_spec_1.fits clobber=yes
dmtcalc input_spec_1.fits input_spec_2.fits  expr="flux=counts/((float)specresp * 0.9*1759.8)" clobber=yes
# devide by binwidth to turn the flux int oa flux DENSITY for marx
dmtcalc input_spec_2.fits input_spec_3.fits  expr="fluxdens=flux/0.1" clobber=yes
dmcopy "input_spec_3.fits[cols energ_hi,fluxdens]" "input_spec_marx.tbl[opt kernel=text/simple]" clobber=yes
dmcopy "input_spec_3.fits[cols energ_lo,energ_hi,flux]" "input_spec_saotrace.tbl[opt kernel=text/simple]" clobber=yes