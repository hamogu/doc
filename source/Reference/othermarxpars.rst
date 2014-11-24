.. _spacecraftpars:


Further |marx| parameters
==========================
|marx| accepts a larger number of parameters. Only a small fraction of those is needed by the average |marx| user and those
parameters are explained in detail in this manual. For each parameter, :ref:`genindex` links to the section that explains its
use. 

However, many parameters are only required for calibration purposes. Their defaults point to a file with calibration
information that is shipped with |marx| or they set a parameter of the the Chandra geometry.
Those files typically should not be changed from those default value. These parameters
are listed here with a short explanation.




XRCF Shutter Control
~~~~~~~~~~~~~~~~~~~~

.. parameter:: Shutters1

   (*default*: `0000`) Enter mirror 1 shutter bitmap (0: open, 1: closed)

.. parameter:: Shutters3 

   (*default*: `0000`) Enter mirror 3 shutter bitmap (0: open, 1: closed)

.. parameter:: Shutters4 

   (*default*: `0000`) Enter mirror 4 shutter bitmap (0: open, 1: closed)

.. parameter:: Shutters6 

   (*default*: `0000`) Enter mirror 6 shutter bitmap (0: open, 1: closed)


HRMA Setup
~~~~~~~~~~
.. parameter:: FocalLength      

   (*default*: `10061.62`) Mirror Focal Length

.. parameter:: HRMA_Use_WFold

   (*default*: `yes`) Use WFold scattering tables?

.. parameter:: HRMA_Use_Blur

   (*default*: `yes`) Use HRMA Blur factors

.. parameter:: HRMA_Ideal

   (*default*: `no`) Assume perfect reflection from HRMA

.. parameter:: WFold_P1_File

   (*default*: `hrma/scat_p1_M.bin`) Enter wfold filename for HRMA

.. parameter:: WFold_H1_File

   (*default*: `hrma/scat_h1_M.bin`) Enter wfold filename for HRMA

.. parameter:: WFold_P3_File

   (*default*: `hrma/scat_p3_M.bin`) Enter wfold filename for HRMA

.. parameter:: WFold_H3_File

   (*default*: `hrma/scat_h3_M.bin`) Enter wfold filename for HRMA

.. parameter:: WFold_P4_File

   (*default*: `hrma/scat_p4_M.bin`) Enter wfold filename for HRMA

.. parameter:: WFold_H4_File

   (*default*: `hrma/scat_h4_M.bin`) Enter wfold filename for HRMA

.. parameter:: WFold_P6_File

   (*default*: `hrma/scat_p6_M.bin`) Enter wfold filename for HRMA

.. parameter:: WFold_H6_File

   (*default*: `hrma/scat_h6_M.bin`) Enter wfold filename for HRMA

.. parameter:: HRMAOptConst

   (*default*: `hrma/iridium.dat`) Enter optical const filename for HRMA

.. parameter:: HRMAOptConstScale

   (*default*: `1.0`) Enter Scale factor for HRMA opt constants

.. parameter:: HRMAVig

   (*default*: `0.9`) Enter HRMA Vignetting factor

.. parameter:: HRMA_Yaw

   (*default*: `0.0`) Enter HRMA Yaw (arcmin)

.. parameter:: HRMA_Pitch

   (*default*: `0.0`) Enter HRMA Pitch (arcmin)

.. parameter:: HRMA_Geometry_File

   (*default*: `hrma/EKCHDOS06.rdb`) Enter HRMA rdb geometry file

.. parameter:: P1Blur

   (*default*: `0.18129215`) Enter HRMA P1 Blur angle (arcsec)

.. parameter:: H1Blur

   (*default*: `0.13995037`) Enter HRMA H1 Blur angle (arcsec)

.. parameter:: P3Blur

   (*default*: `0.11527828`) Enter HRMA P3 Blur angle (arcsec)

.. parameter:: H3Blur

   (*default*: `0.16360829`) Enter HRMA H3 Blur angle (arcsec)

.. parameter:: P4Blur

   (*default*: `0.12891340`) Enter HRMA P4 Blur angle (arcsec)

.. parameter:: H4Blur

   (*default*: `0.098093014`) Enter HRMA H4 Blur angle (arcsec)

.. parameter:: P6Blur

   (*default*: `0.076202759`) Enter HRMA P6 Blur angle (arcsec)

.. parameter:: H6Blur

   (*default*: `0.079767401`) Enter HRMA H6 Blur angle (arcsec)

.. parameter:: H1ScatFactor

   (*default*: `3.2451338`) Enter Scattering Fudge Factor for H1

.. parameter:: P1ScatFactor

   (*default*: `2.8420331`) Enter Scattering Fudge Factor for P1

.. parameter:: H3ScatFactor

   (*default*: `2.4618956`) Enter Scattering Fudge Factor for H3

.. parameter:: P3ScatFactor

   (*default*: `1.7305226`) Enter Scattering Fudge Factor for P3

.. parameter:: H4ScatFactor

   (*default*: `2.9027099`) Enter Scattering Fudge Factor for H4

.. parameter:: P4ScatFactor

   (*default*: `1.0077613`) Enter Scattering Fudge Factor for P4

.. parameter:: H6ScatFactor

   (*default*: `2.0209803`) Enter Scattering Fudge Factor for H6

.. parameter:: P6ScatFactor

   (*default*: `2.1199425`) Enter Scattering Fudge Factor for P6

.. parameter:: HRMA_Cap_X

   (*default*: `10079.771554`) Enter HRMA Cap X position (mm)

.. parameter:: HRMA_P1H1_XOffset

   (*default*: `-3.277664`) Enter HRMA P1H1 X offset (mm)

.. parameter:: HRMA_P3H3_XOffset

   (*default*: `-0.257891`) Enter HRMA P3H3 X offset (mm)

.. parameter:: HRMA_P4H4_XOffset

   (*default*: `0.733315`) Enter HRMA P4H4 X offset (mm)

.. parameter:: HRMA_P6H6_XOffset

   (*default*: `-0.541755`) Enter HRMA P6H6 X offset (mm)

.. parameter:: PointingOffsetY

   (*default*: `-21`) Enter Optical-Axis/Pointing Y Misalignment (arcsec)

.. parameter:: PointingOffsetZ

   (*default*: `12`) Enter Optical-Axis/Pointing Z Misalignment (arcsec)

EA mirror setup
~~~~~~~~~~~~~~~

.. parameter:: MirrorF           

   (*default*: `10.0692`) Enter HRMA focal length (meters)

.. parameter:: MirrorRadius1

   (*default*: `600`) Enter Mirror 1 radius (mm)

.. parameter:: MirrorRadius3

   (*default*: `480`) Enter Mirror 3 radius (mm)

.. parameter:: MirrorRadius4

   (*default*: `425`) Enter Mirror 4 radius (mm)

.. parameter:: MirrorRadius6

   (*default*: `310`) Enter Mirror 6 radius (mm)

.. parameter:: MirrorVig

   (*default*: `0.9`) Enter HRMA Vignetting factor

.. parameter:: MirrorUseEA

   (*default*: `yes`) Use effective area for HRMA?

.. parameter:: MirrorEAFile

   (*default*: `ea-mirror/Ae_s1346.dat`) Enter mirror effective filename

.. parameter:: MirrorBlur

   (*default*: `yes`) Perform mirror blur?

.. parameter:: MirrorBlurFile

   (*default*: `ea-mirror/mirr-ee.bin`) Enter mirror blur filename


Grating Setup and Control
~~~~~~~~~~~~~~~~~~~~~~~~~
Further parameters for the grating setup and control are discussed in detail in :ref:`Gratingefficiency` and
in :ref:`misalignments`.

.. parameter:: RowlandDiameter

   (*default*: `8632.48`) Enter Rowland Torus Diameter (mm)

.. parameter:: GratingOptConsts

   (*default*: `grating/optical-constants.dat`) Enter optical constants filename



HETG Efficiency Table Model Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. parameter:: HETG_Sector1_File

   (*default*: `grating/HETG-1-facet.tbl`) Enter HETG sector file for shell 1

.. parameter:: HETG_Sector3_File

   (*default*: `grating/HETG-3-facet.tbl`) Enter HETG sector file for shell 3

.. parameter:: HETG_Sector4_File

   (*default*: `grating/HETG-4-facet.tbl`) Enter HETG sector file for shell 4

.. parameter:: HETG_Sector6_File

   (*default*: `grating/HETG-6-facet.tbl`) Enter HETG sector file for shell 6

.. parameter:: HETG_Shell1_File

   (*default*: `grating/hetgmp1D1996-11-01greffN0004.dat`) Enter grating efficiency table for shell 1

.. parameter:: HETG_Shell3_File

   (*default*: `grating/hetgmp3D1996-11-01greffN0004.dat`) Enter grating efficiency table for shell 3

.. parameter:: HETG_Shell4_File

   (*default*: `grating/hetgmp4D1996-11-01greffN0004.dat`) Enter grating efficiency table for shell 4

.. parameter:: HETG_Shell6_File

   (*default*: `grating/hetgmp6D1996-11-01greffN0004.dat`) Enter grating efficiency table for shell 6

.. parameter:: HETG_Shell1_Vig

   (*default*: `1.0`) Enter grating vignetting for shell 1

.. parameter:: HETG_Shell3_Vig

   (*default*: `1.0`) Enter grating vignetting for shell 3

.. parameter:: HETG_Shell4_Vig

   (*default*: `1.0`) Enter grating vignetting for shell 4

.. parameter:: HETG_Shell6_Vig

   (*default*: `1.0`) Enter grating vignetting for shell 6

.. parameter:: HETG_Shell1_Theta

   (*default*: `4.725`) Enter dispersion angle for shell 1 (degrees)

.. parameter:: HETG_Shell3_Theta

   (*default*: `4.725`) Enter dispersion angle for shell 3 (degrees)

.. parameter:: HETG_Shell4_Theta

   (*default*: `-5.235`) Enter dispersion angle for shell 4 (degrees)

.. parameter:: HETG_Shell6_Theta

   (*default*: `-5.235`) Enter dispersion angle for shell 6 (degrees)

.. parameter:: HETG_Shell1_dTheta

   (*default*: `1.5`) Enter shell 1 grating alignment error (sigma arcmin)

.. parameter:: HETG_Shell3_dTheta

   (*default*: `1.5`) Enter shell 3 grating alignment error (sigma arcmin)

.. parameter:: HETG_Shell4_dTheta

   (*default*: `1.5`) Enter shell 4 grating alignment error (sigma arcmin)

.. parameter:: HETG_Shell6_dTheta

   (*default*: `1.5`) Enter shell 6 grating alignment error (sigma arcmin)

.. parameter:: HETG_Shell1_Period

   (*default*: `0.400141`) Enter shell 1 grating period (um)

.. parameter:: HETG_Shell3_Period

   (*default*: `0.400141`) Enter shell 3 grating period (um)

.. parameter:: HETG_Shell4_Period

   (*default*: `0.200081`) Enter shell 4 grating period (um)

.. parameter:: HETG_Shell6_Period

   (*default*: `0.200081`) Enter shell 6 grating period (um)

.. parameter:: HETG_Shell1_dPoverP

   (*default*: `162e-6`) Enter shell 1 grating dP/P (rms)

.. parameter:: HETG_Shell3_dPoverP

   (*default*: `162e-6`) Enter shell 3 grating dP/P (rms)

.. parameter:: HETG_Shell4_dPoverP

   (*default*: `146e-6`) Enter shell 4 grating dP/P (rms)

.. parameter:: HETG_Shell6_dPoverP

   (*default*: `146e-6`) Enter shell 6 grating dP/P (rms)



LETG Efficiency Table Model Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. parameter:: LETG_Sector1_File

   (*default*: `grating/LETG-1-facet.tbl`) Enter LETG sector file for shell 1

.. parameter:: LETG_Sector3_File

   (*default*: `grating/LETG-3-facet.tbl`) Enter LETG sector file for shell 3

.. parameter:: LETG_Sector4_File

   (*default*: `grating/LETG-4-facet.tbl`) Enter LETG sector file for shell 4

.. parameter:: LETG_Sector6_File

   (*default*: `grating/LETG-6-facet.tbl`) Enter LETG sector file for shell 6

.. parameter:: LETG_Shell1_File

   (*default*: `grating/letgD1996-11-01greffMARXpr001N0004.dat`) Enter grating efficiency table for shell 1

.. parameter:: LETG_Shell3_File

   (*default*: `grating/letgD1996-11-01greffMARXpr001N0004.dat`) Enter grating efficiency table for shell 3

.. parameter:: LETG_Shell4_File

   (*default*: `grating/letgD1996-11-01greffMARXpr001N0004.dat`) Enter grating efficiency table for shell 4

.. parameter:: LETG_Shell6_File

   (*default*: `grating/letgD1996-11-01greffMARXpr001N0004.dat`) Enter grating efficiency table for shell 6

.. parameter:: LETG_Shell1_Vig

   (*default*: `0.81`) Enter grating vignetting for shell 1

.. parameter:: LETG_Shell3_Vig

   (*default*: `0.84`) Enter grating vignetting for shell 3

.. parameter:: LETG_Shell4_Vig

   (*default*: `0.85`) Enter grating vignetting for shell 4

.. parameter:: LETG_Shell6_Vig

   (*default*: `0.88`) Enter grating vignetting for shell 6

.. parameter:: LETG_Shell1_Theta

   (*default*: `0.0`) Enter dispersion angle for shell 1 (degrees)

.. parameter:: LETG_Shell3_Theta

   (*default*: `0.0`) Enter dispersion angle for shell 3 (degrees)

.. parameter:: LETG_Shell4_Theta

   (*default*: `0.0`) Enter dispersion angle for shell 4 (degrees)

.. parameter:: LETG_Shell6_Theta

   (*default*: `0.0`) Enter dispersion angle for shell 6 (degrees)

.. parameter:: LETG_Shell1_dTheta

   (*default*: `0.617`) Enter shell 1 grating alignment error (sigma arcmin)

.. parameter:: LETG_Shell3_dTheta

   (*default*: `0.617`) Enter shell 3 grating alignment error (sigma arcmin)

.. parameter:: LETG_Shell4_dTheta

   (*default*: `0.617`) Enter shell 4 grating alignment error (sigma arcmin)

.. parameter:: LETG_Shell6_dTheta

   (*default*: `0.617`) Enter shell 6 grating alignment error  (sigma arcmin)

.. parameter:: LETG_Shell1_Period

   (*default*: `0.991216`) Enter shell 1 grating period (um)


HEG Rectangular Grating Bar Model Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. parameter:: HEGVig                     

   (*default*: `0.93`) Enter HEG Grating Vignetting Factor

.. parameter:: hegGold

   (*default*: `0.0444`) Enter HEG gold thickness (microns)

.. parameter:: hegChromium

   (*default*: `0.0111`) Enter HEG chromium thickness (microns)

.. parameter:: hegNickel

   (*default*: `0`) Enter HEG nickel thickness (microns)

.. parameter:: hegPolyimide

   (*default*: `0.978`) Enter HEG polyimide thickness (microns)

.. parameter:: hegPeriod

   (*default*: `0.200081`) Enter HEG period (microns)

.. parameter:: hegdPoverP

   (*default*: `146e-6`) Enter HEG dP/P

.. parameter:: hegBarHeight

   (*default*: `0.4896`) Enter HEG bar height (microns)

.. parameter:: hegBarWidth

   (*default*: `0.1177`) Enter HEG bar width (microns)

.. parameter:: hegNumOrders

   (*default*: `23`) Enter HEG num orders (2n+1)

.. parameter:: hegTheta

   (*default*: `-5.18`) Enter HEG dispersion angle (degrees)

.. parameter:: hegdTheta

   (*default*: `1.5`) Enter HEG alignment error (sigma arcmin)


MEG Rectangular Grating Bar Model Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. parameter:: MEGVig                     

   (*default*: `0.93`) Enter MEG Grating Vignetting Factor

.. parameter:: megGold

   (*default*: `0.0228`) Enter MEG gold thickness (microns)

.. parameter:: megChromium

   (*default*: `0.0057`) Enter MEG chromium thickness (microns)

.. parameter:: megNickel

   (*default*: `0.0`) Enter MEG nickel thickness (microns)

.. parameter:: megPolyimide

   (*default*: `0.543`) Enter MEG polyimide thickness (microns)

.. parameter:: megPeriod

   (*default*: `0.400141`) Enter MEG period (microns)

.. parameter:: megdPoverP

   (*default*: `162e-6`) Enter MEG dP/P

.. parameter:: megBarHeight

   (*default*: `0.3780`) Enter MEG bar height (microns)

.. parameter:: megBarWidth

   (*default*: `0.2161`) Enter MEG bar width (microns)

.. parameter:: megNumOrders

   (*default*: `23`) Enter MEG num orders (2n+1)

.. parameter:: megTheta

   (*default*: `4.75`) Enter MEG dispersion angle (degrees)

.. parameter:: megdTheta

   (*default*: `1.5`) Enter MEG alignment error (sigma arcmin)


LEG Rectangular Grating Bar Model Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.. parameter:: LEGVig                                                                 

   (*default*: `0.8346`) Enter LEG Grating Vignetting Factor                          

.. parameter:: legGold

   (*default*: `0.0`) Enter LEG gold thickness (microns)

.. parameter:: legChromium

   (*default*: `0`) Enter LEG chromium thickness (microns)

.. parameter:: legNickel

   (*default*: `0`) Enter LEG nickel thickness (microns)

.. parameter:: legPolyimide

   (*default*: `0.0`) Enter LEG polyimide thickness (microns)

.. parameter:: legPeriod

   (*default*: `0.991216`) Enter LEG period (microns)

.. parameter:: legdPoverP

   (*default*: `8.67592e-5`) Enter LEG dP/P

.. parameter:: legBarHeight

   (*default*: `0.4615`) Enter LEG bar height (microns)

.. parameter:: legBarWidth

   (*default*: `0.5566`) Enter LEG bar width (microns)

.. parameter:: legTheta

   (*default*: `0.0`) Enter LEG dispersion angle (degrees)

.. parameter:: legdTheta

   (*default*: `1.4`) Enter LEG alignment error (sigma arcmin)

.. parameter:: legNumOrders

   (*default*: `41`) Enter LEG num orders (2n+1)

.. parameter:: legFineNumOrders

   (*default*: `19`) Enter LETG Fine Grating num orders (2n+1)

.. parameter:: legCoarseNumOrders

   (*default*: `11`) Enter LETG Coarse Grating num orders (2n+1)


ACIS Model Parameters
~~~~~~~~~~~~~~~~~~~~~
.. parameter:: ACIS_Exposure_Time

   (*default*: `3.2`) Enter ACIS exposure time (sec)

.. parameter:: ACIS_Frame_Transfer_Time

   (*default*: `0.041`) Enter ACIS frame transfer time (sec)

.. parameter:: ACIS_Gain_Map_File

   (*default*: `acis/acisD1999-12-10gain_marxN0001_110.fits`) Enter ACIS gain map file

.. parameter:: ACIS_eV_Per_PI

   (*default*: `14.6`) eV per PI bin

.. parameter:: ACIS-S0-QEFile

   (*default*: `acis/s0_w168c4r_eff_898_release.dat`) Enter ACIS-S FS QE filename

.. parameter:: ACIS-S0-FilterFile

   (*default*: `acis/acis_s_xray_trans_1198.dat`) Enter ACIS-S FS Filter filename

.. parameter:: ACIS-S1-QEFile

   (*default*: `acis/s1_w140c4r_eff_898_release.dat`) Enter ACIS-S FS QE filename

.. parameter:: ACIS-S1-FilterFile

   (*default*: `acis/acis_s_xray_trans_1198.dat`) Enter ACIS-S FS Filter filename

.. parameter:: ACIS-S2-QEFile

   (*default*: `acis/s2_w182c4r_eff_898_release.dat`) Enter ACIS-S FS QE filename

.. parameter:: ACIS-S2-FilterFile

   (*default*: `acis/acis_s_xray_trans_1198.dat`) Enter ACIS-S FS Filter filename

.. parameter:: ACIS-S3-QEFile

   (*default*: `acis/s3_w134c4r_eff_898_release.dat`) Enter ACIS-S FS QE filename

.. parameter:: ACIS-S3-FilterFile

   (*default*: `acis/acis_s_xray_trans_1198.dat`) Enter ACIS-S FS Filter filename

.. parameter:: ACIS-S4-QEFile

   (*default*: `acis/s4_w457c4_eff_898_release.dat`) Enter ACIS-S FS QE filename

.. parameter:: ACIS-S4-FilterFile

   (*default*: `acis/acis_s_xray_trans_1198.dat`) Enter ACIS-S FS Filter filename

.. parameter:: ACIS-S5-QEFile

   (*default*: `acis/s5_w201c3r_eff_898_release.dat`) Enter ACIS-S FS QE filename

.. parameter:: ACIS-S5-FilterFile

   (*default*: `acis/acis_s_xray_trans_1198.dat`) Enter ACIS-S FS Filter filename



HRC Model Parameters
~~~~~~~~~~~~~~~~~~~~
.. parameter:: HRC-I-BlurSigma  

   (*default*: `0.0077`) Enter HRC-I pixel Blur (RMS mm)

.. parameter:: HRC-I-QEFile

   (*default*: `hrc/HRC_I_csi_qe_model.dat`) Enter HRC-I QE File

.. parameter:: HRC-I-UVISFile

   (*default*: `hrc/uvisnlr.1174.82.dat`) Enter HRC-I UV/IS file for region 0

.. parameter:: HRC-S-BlurSigma

   (*default*: `0.0077`) Enter HRC-S pixel Blur (RMS mm)

.. parameter:: HRC-S-QEFile0

   (*default*: `hrcs_mcpqe_030900_pr001.dat`) Enter HRC QE File for MCP 0

.. parameter:: HRC-S-QEFile1

   (*default*: `hrcs_mcpqe_030900_pr001.dat`) Enter HRC QE File for MCP 1

.. parameter:: HRC-S-QEFile2

   (*default*: `hrcs_mcpqe_030900_pr001.dat`) Enter HRC QE File for MCP 2

.. parameter:: HRC-S-UVISFile0

   (*default*: `hrc/uvisnlr.1052.82.dat`) Enter HRC UV/IS file for region 0

.. parameter:: HRC-S-UVISFile1

   (*default*: `hrc/hrcs_r2.dat`) Enter HRC UV/IS file for region 1

.. parameter:: HRC-S-UVISFile2

   (*default*: `hrc/uvisnlr.1092.82.dat`) Enter HRC UV/IS file for region 2

.. parameter:: HRC-S-UVISFile3

   (*default*: `hrc/uvisnlr.565.82.dat`) Enter HRC UV/IS file for region 3


HESF Model Parameters
~~~~~~~~~~~~~~~~~~~~~
.. parameter:: HRC-HESF         

   (*default*: `yes`) Use HESF (AKA Drake Flat) (yes/no)

.. parameter:: HESFOffsetX

   (*default*: `26.3`) Enter the HESF X offset of lower plate (mm)

.. parameter:: HESFOffsetZ

   (*default*: `-5.359`) Enter the HESF Z offset of lower plate (mm)

.. parameter:: HESFGapY1

   (*default*: `28.7`) Enter the HESF Gap Offset Y1

.. parameter:: HESFGapY2

   (*default*: `36.7`) Enter the HESF Gap Offset Y2

.. parameter:: HESFN

   (*default*: `2`) Enter the number of HESF facets

.. parameter:: HESFLength

   (*default*: `294.0`) Enter length of HESF plate

.. parameter:: HESFCrWidth

   (*default*: `15.7`) Enter HESF Chromium strip width

.. parameter:: HESFOptConstCr

   (*default*: `hrc/chromium.dat`) Enter the Chromium Optical constant filename for the HESF

.. parameter:: HESFOptConstC

   (*default*: `hrc/carbon.dat`) Enter the Carbon Optical constant filename for the HESF

.. parameter:: HESFHeight1

   (*default*: `22.3`) Enter the height of HESF 1 (mm)

.. parameter:: HESFTheta1

   (*default*: `4.5`) Enter the angle of HESF 1 (degrees)

.. parameter:: HESFHeight2

   (*default*: `50.0`) Enter the height of HESF 2 (mm)

.. parameter:: HESFTheta2

   (*default*: `7`) Enter the angle of HESF 2 (degrees)

.. parameter:: HESFHeight3

   (*default*: `0`) Enter the height of HESF 3 (mm)

.. parameter:: HESFTheta3

   (*default*: `0`) Enter the angle of HESF 3 (degrees)

.. parameter:: HESFHeight4

   (*default*: `0`) Enter the height of HESF 4 (mm)

.. parameter:: HESFTheta4

   (*default*: `0`) Enter the angle of HESF 4 (degrees)


Flat Field Model Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. parameter:: FF_MinY

   (*default*: `-150`) Enter FlatField Aperture min Y value (mm)

.. parameter:: FF_MaxY

   (*default*: `150`) Enter FlatField Aperture max Y value (mm)

.. parameter:: FF_MinZ

   (*default*: `-10`) Enter FlatField Aperture min Z value (mm)

.. parameter:: FF_MaxZ

   (*default*: `10`) Enter FlatField Aperture max Z value (mm)

.. parameter:: FF_XPos

   (*default*: `10000`) Enter FlatField Aperture X location (mm)


.. _internalditherpars:

Dither/Aspect Parameters
~~~~~~~~~~~~~~~~~~~~~~~~
The most important parameters that control the dither model are described in
:ref:`simulatingaspect`. In the following we list parameters that control the internal
|marx| dither model, if selected by :par:`DitherModel`.


.. parameter:: DitherAmp_RA

   (*default*: `8`)  Amplitude for RA dither (arcsecs)

.. parameter:: DitherAmp_Dec

   (*default*: `8`)  Amplitude for Dec dither (arcsecs)

.. parameter:: DitherAmp_Roll

   (*default*: `0`)  Amplitude for Roll dither (arcsecs)

.. parameter:: DitherPeriod_RA

   (*default*: `1000`)  Period for RA dither (secs)

.. parameter:: DitherPeriod_Dec

   (*default*: `707`)  Period for Dec dither (secs)

.. parameter:: DitherPeriod_Roll

   (*default*: `1e+05`)  Period for Roll dither (secs)

.. parameter:: DitherPhase_RA

   (*default*: `0`)  Phase for RA dither (radians)

.. parameter:: DitherPhase_Dec

   (*default*: `0`)  Phase for Dec dither (radians)

.. parameter:: DitherPhase_Roll

   (*default*: `0`)  Phase for Roll dither (radians)
