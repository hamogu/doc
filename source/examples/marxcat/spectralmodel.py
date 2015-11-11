# set source properties
set_source(xsvapec.a1)
a1.Ne = 1.2
a1.Fe = 0.8

# get source
my_src = get_source()

# set energy grid
bin_width = 0.01
energies = np.arange(0.03, 12., bin_width)

# evaluate source on energy grid
flux = my_src(energies)

### EQ Peg A ###
# check that out! Download and take number from real data.
a1.norm = 2e-3
a1.kT = 0.5

# Sherpa uses the convention that an energy array holds the LOWER end of the bins;
# Marx that it holds the UPPER end of a bin.
# Thus, we need to shift energies and flux be one bin.
# Also, we need to divide the flux by the bin width to obtain the flux density.
save_arrays("EQPegA_flux.tbl", [energies[1:], flux[:-1] / bin_width], ["keV","photons/s/cm**2/keV"], ascii=True)

### EQ Peg B ###
a1.norm = 1e-3
a1.kT = 0.7
# check that that;s actually different.
# if not, call my_src = get_source() again.
flux = my_src(energies)

save_arrays("EQPegB_flux.tbl", [energies[1:], flux[:-1] / bin_width], ["keV","photons/s/cm**2/keV"], ascii=True)
