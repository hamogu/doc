.. _sect-ex-simobs:

Replicating a Chandra Observation
=================================

The example presented here was originally designed to see how well the
|marx| PSF compares to that of an actual Chandra observation of a far
off-axis source.  We will also be comparing the |marx| intrinsic PSF to
that of `SAOTrace`_.  Hence, this example will serve several purposes:

- How to simulate an existing observation.
- How to use `SAOTrace`_ dithered rays with |marx|.
- To see how the `SAOTrace`_ and |marx| PSFs compare to the observed
  PSF for a far off-axis source.

In this example, we will use the 1999 Chandra calibration observation
of LMC X-1 observed about 25 arc-minutes off-axis with the ACIS
detector (ObsID 1068). We download the data with :ciao:`download_chandra_obsid`
and reprocess it with :ciao:`chandra_repro`.

The figure shows the source as seen in `ds9`_:

.. _fig-ex-simobs-obspsf:

.. figure:: obs1068_chandra.*
   :alt: 
   :align: center

   ds9 image of the PSF

The crosshairs in :ref:`fig-ex-simobs-obspsf` mark the position where the
support strut shadows meet
as determined by eye: ra=84.91093 degrees, dec=-69.74348 degrees,
(x,y)=(5256,6890). This coordinate will be used as the position of the
source.  For this observation, this coordinate falls on ACIS-4 (S0).

Creating the source spectral file
---------------------------------

For an accurate simulation of an observed source, it is important to
make the detector configuration match that of the observation as closely
as possible.  And since the PSF is energy dependent, a rough idea
of the energy dependence of the incident source flux must be obtained.
There are several approaches to get this input spectrum. One way would be to
extract the spectrum, fit a model using `XSPEC`_, `ISIS`_, or
`Sherpa` and write an input file from the model as we did in several previous
examples.

Just to illustrate another approach, we will do something different here. (But
do not worry if that looks like black magic to you; you can download the input
spectrum file below or select another method to get the input spectrum.
We just think it is instructive to show something slightly different in each
example.)

Here, we will simply extract the
counts in a region containing the observed PSF and dividing it by the
effective area.  This is known as "flux-correction", and involves no
spectral fitting.  Strictly speaking, the validity of this technique
assumes that spectrum does not vary much over the scale of the RMF.

The first step is to create the ARF to be used for the flux-correction.
The creation of the ARF is straightforward via the Bourne shell script:

.. literalinclude:: runmkarf.sh
   :language: bash

The next step is to extract the counts in the PSF and divide by the
ARF to get the flux corrected spectrum. 
Here we show a way using only standard `CIAO`_ tools; there are some comments
on what's happening in the scripts.

First, create a region file containing the source events with
:ciao:`dmellipse`, and use :ciao:`dmextract` to create the PI histogram.  

.. literalinclude:: extract.sh
   :language: bash

The energy binning of the ARF and extracted spectrum are the same. Thus, we can
now calculate the corrected spectrum by dividing that flux by the effective
area and the exposure time. 
There is an extra factor of 0.9, because the ARF assumes that 100% of the
PSF are included in the data extraction, while the ellipse above only contains
90% of the counts. Also, we divide by the exposure time (about 1760 s).
 We write from intermediary files to copy columns back and
forth and write the spectrum out as an ASCII table in the end.

.. literalinclude:: spectrum2ascii.sh
   :language: bash

The resulting ASCII tables :download:`for marx <input_spec_marx.tbl>` and
:download:`for SAOTrace/Chart <input_spec_saotrace.tbl>` with the spectrum
will be input into both |marx| and `SAOTrace`_. The spectrum is the same, but
the format of the tables is two columns (energy, flux density) for |marx| and
three columns (lower energy, upper energy, flux density) for `SAOTrace`_ / `ChaRT`_)

Running |marx| (without SAOTrace)
---------------------------------
Running |marx| for this example does not differ much from any of the previous
example. We use the :par:`SpectrumFile` parameter to input the source spectrum
we estimated above and set the remaining parameters to match the setting of the
observation for the pointing direction, exposure time, etc. To get the numbers
we display the header (e.g. in `ds9`_) and manually look for the required fits
header keywords (e.g. ``EXPOSURE`` for :par:`ExposureTime`, ``RA_NOM`` for
:par:`RA_Nom``, etc.).

.. literalinclude:: marxonly.sh
   :language: bash


Running SAOTrace / Chart and |marx|
-----------------------------------

