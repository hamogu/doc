import numpy as np

# set source properties
set_source(xsphabs.a * xspowerlaw.p)
a.nH = 0.001
p.PhoIndex = 1.8
p.norm = 0.1

# get source
my_src = get_source()

# set energy grid
bin_width = 0.01
energies = np.arange(0.03, 12., bin_width)

# evaluate source on energy grid
flux = my_src(energies)

# Sherpa uses the convention that an energy array holds the LOWER end of the bins;
# Marx that it holds the UPPER end of a bin.
# Thus, we need to shift energies and flux by one bin.
# Also, we need to divide the flux by the bin width to obtain the flux density.
save_arrays("source_flux.tbl", [energies[1:], flux[:-1] / bin_width], ["keV","photons/s/cm**2/keV"], ascii=True)
