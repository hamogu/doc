.. _sect-ex-marxcat:

Simulating two overlapping sources
==================================

In each run of |marx| the user can choose one and only one source from the list
in :ref:`sect-sourcemodels`. Most of these sources are simple geometric shapes
like a point or a disk. The :ref:`sect-imagesource` allows the user to specify an itensity image as input to define a complicated morphology on the sky, but the spectrum is the same in every position.

If spectrum *and* intensity change with position, the user can write his/her own C-code to generate the photons as described in :ref:`sect-usersource`. Some of those codes are available for download, see :ref:`sect-sourcemodels` for links.

However, in most cases it is easier to run |marx| several times and use :marxtool:`marxcat` to combine the simulations.

In this example we want to simulate a binary star, where both components are separated by only a few arcseconds. In the center of the field-of-view that is enough to separate the images of component A and B, but what happens when we insert a grating? Will the dispersed spectra overlap, or can they be separated in the data?

The parameters in the following example are inspired by the observations of the M-dwarf binary EQ Peg (ObsID 8453). An analysis is presented by `Liefke et al. (2008) <http://adsabs.harvard.edu/abs/2008A%26A...491..859L>`_. We will run two |marx| simulations, one for EQ Peg A and one for EQ Peg B. The parameters of the observations (poining coordinates, roll angle, exposure time, grating) have to be the same for both simulations, but the parameters for the sources (coordinates, count rate, spectrum) are different.

Creating a file with the input spectra
--------------------------------------
First, we need to generate the input spectra. For this example, we use `Sherpa`_, but `XSPEC`_ or `ISIS`_ work very similar.
We need two 2-column text files that tabulate the model flux [photons/sec/keV/cm^2] (second column) as a function of energy [keV] (first column).

Stars are generally well described by an optically thin, collisionally excited plasma. We use a model with only a single temperature component with a different temperature for EQ Peg A and EQ Peg B and slightly non-solar abundances as suggested by `Liefke et al. (2008) <http://adsabs.harvard.edu/abs/2008A%26A...491..859L>`_.

.. sourceinclude:: spectralmodel.py
   :language: python 
   :indent: "sherpa> "

	      
More details about the format of the |marx| input spectrum can be found at :par:`SpectrumFile`.

Running |marx|
--------------

We run |marx| twice - once for each star.

.. literalinclude:: runmarx.inc
   :language: bash

The :par:`SourceFlux` parameter may be used to indicate the integrated flux of
the spectrum. The value of ``-1`` means that the integrated flux is taken
from the file. The results of the simulation will be written to sub-directories
called ``EQPegA`` and ``EQPegB``, as specified by the :par:`OutputDir`
parameter. We use :marxtool:`marxcat` to combine both simulations in the
directory ``EQPeg_both``:


.. literalinclude:: runmarxcat.inc
   :language: bash

In the simulation we know exactly which photon comes from which star, so we can generate three fits files, one for EQ Peg A only, one for EQ PEg B only, and one that contains both sources, similar to the observed data.

.. literalinclude:: runmarx2fits.inc
   :language: bash

The fits files can be further processed
with standard `CIAO`_ tools.  As some of these tools require the aspect
history, the :marxtool:`marxasp` program is used to create an aspect
solution file. Since both simulations used the same pointing and dither, we can
use the same asol file for all three fits files.

.. literalinclude:: runmarxasp.inc
   :language: bash

Analyzing the results
---------------------
	      
It is interesting to look at the event file with a viewer such as
`ds9`_. The grating spectra of EQ Peg A and EQ Peg B are close to each other on
the detector, and we'll now test if the spectrum of EQ Peg A contaminates the
spectrum of EQ Peg B.

.. _fig-ex-marxcat-image:

.. figure:: eqpeg_image.*
   :alt: Two spectra on a detector very close to each other.
   :align: center

   Small section of the detector image of the combined simulation

   The grating spectra of both sources are located fairly close to each
   other. On the left is an MEG arm, the fainter signal of an HEG arm is
   seen on the right. The green lines mark the extraction regions for the EQ Peg B
   MEG and HEG spectra. :ciao:`tgextract` subdivides this green region into
   source and background regions for spectral extraction.

We use `CIAO`_ to extract the grating spectrum from ``EQPegB.fits`` and
``EGPeg_both.fits``.

.. literalinclude:: eqpeg_ciao.sh
   :language: bash

Now, we want to make use of our |marx| simulation to see how much the spectrum
of EQ Peg A contaminates the extracted grating spectrum of EQ Peg B.
We compare the spectra in `Sherpa`_. The difference between the two spectra in
some of the lines is caused by photons from EQ Peg A that fall in the
extraction region of EQ Peg B. 


.. _fig-ex-marxcat-spectra:

.. figure:: eqpeg_spectra.*
   :alt: The spetra differ only at short wavelength.
   :align: center

   Contaminated and clean spectrum extracted for EQ Peg B (MEG order +1).

   The red spectrum shows the uncontaminated spectrum of EQ Peg B, extracted
   from the simulation that contained only one source. The black spectrum is
   extracted from the combined fits file that contains both EQ Peg A and EQ Peg
   B.
   
Looking at this figure, we see that both spectra are very similar, but not
identical - that is the contamination by EQ Peg A.

:ciao:`tgextract` uses only the innermost part of the green region in figure
:ref:`fig-ex-marxcat-image` for the source spectrum and apparently that is
narrow enough to avoid most of the contamination. Still, if we want to measure
or fit lines in the EQ Peg B spectrum we have to be careful. 

|marx| simulations do not contain any background, but real data does and one
common (although arguably not the best) approach is to subtract a background
spectrum from the data. What would happen if we blindly subtracted
the background from the EQ Peg B spectrum?

.. _fig-ex-marxcat-background:

.. figure:: eqpeg_background.*
   :alt: spectrum with negative bins
   :align: center

   "Background subtracted" spectrum for EQ Peg B

   Because the bright spectrum
   of EQ Peg A falls in the detector region where the background is measured,
   the background is overestimated and causes bins with negative fluxes here.

Figure :ref:`fig-ex-marxcat-background` shows that we end up with a spectrum
with a significant number of negative bins because the much brighter spectrum of EQ
Peg A falls in the region where :ciao:`tgextract` extracts the background,
leading to an overestimate of the background.

Summary
-------
This example shows how :marxtool:`marxcat` can be used to build up a more complex distribution of sources on the sky from simple components. We can asses how much the sources overlap and compare the simulated spectra of each component and thus estimate the contamination in the real data.

In this example we simulated grating spectra of a binary star, but the same principle works for all cases where sources overlap on the detector, e.g. a cluster of galaxies with a foreground HMXB, binary AGN, or imaging of a dense star forming region.
