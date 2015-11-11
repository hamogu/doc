# Fix coordiantes of sources.
# Select good roll angle to show what I want.

marx SourceFlux=-1 SpectrumType="FILE" SpectrumFile="EQPegA_flux.tbl" \
       ExposureTime=5e5 TStart=2015.5 \
       OutputDir=EQPegA GratingType="HETG" DetectorType="ACIS-S" \
       DitherModel="INTERNAL" RA_Nom=352.9675 Dec_Nom=19.94725 Roll_Nom=50 \
       SourceRA=30 SourceDEC=40

 marx SourceFlux=-1 SpectrumType="FILE" SpectrumFile="EQPegB_flux.tbl" \
       ExposureTime=5e5 TStart=2015.5 \
       OutputDir=EQPegB GratingType="HETG" DetectorType="ACIS-S" \
       DitherModel="INTERNAL" RA_Nom=352.9675 Dec_Nom=19.94725 Roll_Nom=50 \
       SourceRA=30 SourceDEC=40