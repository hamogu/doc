
import sherpa
#### Make a dummy response ####
energies = np.arange(0.03, 12., .01)
one = np.ones(len(energies)-1)
dummyrsp = sherpa.astro.data.DataRMF('dummy rsp', len(energies)-1,
                                      energies[:-1], energies[1:],
                                      one, one, one, one, energies[:1], energies[1:])
dummyrmf = sherpa.astro.instrument.RMF1D(dummyrsp)

# load dummy data (all ones)
load_arrays(1, np.arange(len(one)), one, DataPHA)
# load dummy response
set_rmf(dummyrmf)

# set source properties
set_source(xsphabs.a * xspowerlaw.p)
a.nH = 0.001
p.PhoIndex = 1.8
p.norm = 0.1

set_analysis("energy", factor=1)

pl = get_source_plot()
fluxdensity = pl.y
energy = pl.xhi
save_arrays("source_flux.tbl", [energy,fluxdensity], ["keV","photons/s/cm**2/keV"], ascii=True)
