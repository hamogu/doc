cp mysim.par mysim_disk.par
# New output dir for the Disk
pset mysim_disk.par OutputDir="hetg_pldisk"

# Change the SourceType:
pset mysim_disk.par SourceType="DISK"
# a thin disk with average radius ~ 2.0"
pset mysim_disk.par S-DiskTheta0=1.7
pset mysim_disk.par S-DiskTheta1=2.3

# Run the second simulation:
marx @@mysim_disk.par
