dmcopy "obs1068.arf[cols energ_hi,specresp]" input_spec.fits clobber=yes
dmpaste input_spec.fits "obs1068.pi[cols counts]" input_spec_1.fits clobber=yes
dmtcalc input_spec_1.fits input_spec_2.fits  expr="fluxdens=counts/((float)specresp * 0.9)"
dmcopy "input_spec_2.fits[cols energ_lo,fluxdens]" "input_spec.tbl[opt kernel=text/simple]" clobber=yes