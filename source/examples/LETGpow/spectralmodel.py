# Sherpa code

dataspace1d(0.03, 12., .01)
set_source(xsphabs.a * xspowerlaw.p)
a.nH = 0.001
p.PhoIndex = 1.8
p.norm = 0.1
pl = get_source_plot()
fluxdensity = pl.y
energy = pl.x

save_arrays("source_flux.tbl", [energy,fluxdensity], ["keV","photons/s/cm**2/keV"], ascii=True, clobber=True)
