# Make a par file for my marx simulation:
cp marx.par mysim.par

# set the spectrum file to use:
pset mysim.par SpectrumType="FILE"
pset mysim.par SpectrumFile="plawflux_hetg.tbl"
pset mysim.par SourceFlux=-1

# Set other parameters of the simulation:
# Using 50 ks
pset mysim.par ExposureTime=50000
pset mysim.par OutputDir="hetg_plaw"
pset mysim.par DitherModel="INTERNAL"

# Use the HETG with ACIS-S:
pset mysim.par GratingType="HETG"
pset mysim.par DetectorType="ACIS-S"

# Some other parameters it can be useful to set:

# Date of observation (effects ACIS QE)
pset mysim.par TStart=2009.50
# Roll of the observation: 0 puts average dispersion along E -- W.
pset mysim.par Roll_Nom=0.0

# Source RA/DEC (degrees)
pset mysim.par SourceRA=250.000
pset mysim.par SourceDEC=-54.000
# Pointing RA/DEC (degrees)
pset mysim.par RA_Nom=250.000
pset mysim.par Dec_Nom=-54.000

# Finally,
# Run the simulation:
marx @@mysim.par
