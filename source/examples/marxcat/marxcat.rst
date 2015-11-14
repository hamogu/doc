.. _sect-ex-marxcat:

Simulating two overlapping sources
==================================

In each run of |marx| the user can choose one and only one source from the list in :ref:`sect-sourcemodels`. Most of these source are simple geometric shapes like a point or a disk. The :ref:`sect-imagesource` allows to specify an itensity image as input to define a complicated morphology on the sky, but the spectrum is the same in every position.

If spectrum *and* intensity change with position, the user can write his/her own C-code to generate the photons as described in :ref:`sect-usersource`. Some of those codes are available for download, see :ref:`sect-imagesource` for links.

However, in most cases it is easier to run |marx| several times and use the :marxtool:`marxcat` to combine the simulations.

In this example we want to simulate a binary star, where both components are separated by only a few arcseconds. In the center of the field-of-view that is enough to separate the images of component A and B, but what happens when we insert a grating? Will the dispersed spectra overlap, or can they be separated in the data?

The parameters in the following example are inspired by (but not identical to) the observations of the M-dwarf binary EQ Peg (ObsID 8453). An analysis is presented by `Liefke et al. (2008) <http://adsabs.harvard.edu/abs/2008A%26A...491..859L>`_. We will run two |marx| simulations, one for EQ Peg A and one for EQ Peg B. The parameters of the observations (poining coordinates, roll angle, exposure time, grating) have to be the same for both simulations, but the parameters for the sources (coordinates, count rate, spectrum) are different.

Creating a file with the input spectra
--------------------------------------
First, we need to generate the spectra that we input. For this example, we use `Sherpa`_, but `XSPEC`_ or `ISIS`_ work very similar.
We need two 2-column text files that tabulate the model flux [photons/sec/keV/cm^2] (second column) as a function of energy [keV] (first column).

Stars are generally well described by an optically thin, collisionally excited plasma. We use a model with only a single temperature component with a slightly different temperature for EQ Peg A and EQ Peg B and slightly non-solar abundances as suggested by `Liefke et al. (2008) <http://adsabs.harvard.edu/abs/2008A%26A...491..859L>`_.

.. sourceinclude:: spectralmodel.py
   :language: python 
   :indent: "sherpa> "

	      
More details about the format of the |marx| input spectrum can be found at :par:`SpectrumFile`.
Note, that the parameter :par:`SourceFlux` sets the normalization of the flux; if the normalization of the model file should be used, set :par:`SourceFlux=-1`.

Running |marx|
--------------

Then, we run |marx| twice - once for each star.

.. literalinclude:: runmarx.inc
   :language: bash

The :par:`SourceFlux` parameter may be used to indicate the integrated flux of
the spectrum. The value of ``-1``
 means that the integrated flux is to be taken from the file. 
The results of the
simulation will be written to subdirectories called ``EQPegA`` and ``EQPegB``, as specified by the :par:`OutputDir` parameter. We use :marxtool:`marxcat` to combine both simulations in the directory ``EQPeg_both``:

.. literalinclude:: runmarxcat.inc
   :language: bash

In this simulation we know exactly which photon comes from which star, so we can generate three fits file, one for EQ Peg A only, one for EQ PEg B only, and one that contains both sources, similar to the observed data.

.. literalinclude:: runmarx2fits.inc
   :language: bash

The fits file ``letgplaw_evt1.fits`` can be further processed
with standard `CIAO`_ tools.  As some of these tools require the aspect
history, the :marxtool:`marxasp` program is used to create an aspect
solution file. Since both simulations used the same pointing and dither, the asol file is the same for each of the three fits files.

.. literalinclude:: runmarxasp.inc
   :language: bash

Analysing the results
---------------------
	      
It is interesting to look at the event file with a viewer such as
`ds9`_.  
The HETG grating has two parts, the HEG and the MEG. The grating spectra from the HEG and MEG form the shape of an X on the detector. The two X shapes from EQ Peg A and EQ Peg B overlap.

.. _fig-ex-marxcat-ds9:

.. figure:: eqpeg_ds9.*
   :alt: The two X shapes overlap very close to the source.
   :align: center

   Detector image of the combined simulation for EQ Peg A and EQ Peg B

   The grating spectra of both sources overlap very close to the source. Thus, care should be taken when fitting the short wavelengths in the extracted spectrum, while the longer wavelength regions are unaffected.


.. literalinclude:: eqpeg_ciao.sh
   :language: bash

We use `CIAO`_ to extract the grating spectrum from ``EQPegB.fits`` and ``EGPeg_both.fits``.
We compare the spectra in `Sherpa`_. The difference between the two spectra shown is caused by photons from EQ Peg A that fall in the extraction region of EQ Peg B. The figure shows that this contamination is only relevant for very short wavelengths. Thus, when we analyze the real, observed data from the EQ Peg system, we should probably exclude the low wavelengths from the fit to avoid contamination from the other member of the binary.

.. _fig-ex-marxcat-spectra:

.. figure:: eqpeg_spectra.*
   :alt: The spetra differ only at short wavelength.
   :align: center

   Contaminated and clean spectrum extracted for EQ Peg B.

   The black spectrum shows the uncontaminated spectrum of EQ Peg B, extracted from the simulation that contained only one source. The red spectrum is extracted from the combined fits file that contains both EQ Peg A and EQ Peg B. At short wavelengths this sprectrum is higher, because some photons from EQ Peg A fall into the extraction region of EQ Peg B. Remember that |marx| is a Monte-Carlo simulation, so the amount of contamination will be different when this example is re-run. This figure is made with `Sherpa`_ using the following script :download:`compare_eqpeg.py`.


Summary
-------
This example shows how :marxtool:`marxcat` can be used to build up a more complex distribution of sources on the sky from simple components. We can asses how much the sources overlap and compare the simulated spectra of each component and thus estimate the contamination in the real data.

In this example we simulated grating spectra of a binary star, but the same principle works for all cases where sources overlap on the detector, e.g. a cluster of galaxies with a foreground HMXB, binary AGN, or imaging of a dense star forming region.
