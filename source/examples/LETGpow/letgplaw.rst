.. _sect-ex-letgplaw:

Simulating an LETG/ACIS-S observation
=====================================

In this example, we simulate an LETG/ACIS-S observation with |marx|.
The primary goal of this exercise is to see how well |marx| can
simulate this instrument combination by performing a spectral analysis
of the result.  For simplicity, we assume an on-axis point source and an
absorbed powerlaw spectrum with a column density of 10^19 atoms/cm^2, a
spectral index of 1.8. Rather than specifying an
exposure time for the observation as in the other examples, here we
specify the desired number of detected events.  In this case, the
simulation will be run until 1,000,000 (1e6) events have been
detected.

.. _creating_sherpa_spectrum:

Creating an input spectrum from a Sherpa model
----------------------------------------------

The first step is to create a 2-column text file that tabulates
the absorbed powerlaw flux [photons/sec/keV/cm^2] (second column)
as a function of energy [keV] (first column).  The easiest way to create
such a file is to make use of a spectral modeling program.  For a change, we
will use the `Sherpa`_ program in this example.

We chose the specific physical model (a positive powerlaw with an
unrealistically high flux) because we want
to construct a really detailed picture of the features seen in the PSF and we
need a large number of photons over a wide range of energies:

.. sourceinclude:: spectralmodel.py
   :language: python 
   :indent: "sherpa> "

More details about the format of the |marx| input spectrum can be found at :par:`SpectrumFile`.
Note, that the parameter :par:`SourceFlux` sets the normalization of the flux; if the
normalization of the model file should be used, set :par:`SourceFlux=-1`.


Running marx
------------

The next step is to run |marx| in the desired configuration.  Some
prefer to use tools such as :marxtool:`pset` to update the ``marx.par``
file and then run |marx|.  Here, the parameters will be explicitly
passed to |marx| via the command line:

.. literalinclude:: runmarx.inc
   :language: bash

Note the use of a *negative* value of the :par:`NumRays` parameter.
This tells |marx| that the simulation is to continue until the absolute
value of that number of rays have been detected.  
The :par:`SourceFlux` parameter may be used to indicate the integrated flux of
the spectrum. The value of ``-1``
as given above means that the integrated flux is to be taken from the file. 
The results of the
simulation will be written to a subdirectory called ``letgplaw``, as
specified by the :par:`OutputDir` parameter.  After the simulation has
completed, a standard Chandra event file may be created using the :marxtool:`marx2fits`
program:

.. literalinclude:: runmarx2fits.inc
   :language: bash

The fits file ``letgplaw_evt1.fits`` can be further processed
with standard `CIAO`_ tools.  As some of these tools require the aspect
history, the :marxtool:`marxasp` program is used to create an aspect
solution file that matches the simulation:

.. literalinclude:: runmarxasp.inc
   :language: bash

It is interesting to look at the event file with a viewer such as
`ds9`_.  Here we use :ciao:`dmimg2jpg`, which displays an RGB image of the events
projected to the sky plane.

.. _fig-ex-leg:

.. figure:: image_rgb.*
   :align: center
   :alt: LETGS detector plane image. 

   RGB image of the event file

   The energy bands were color-coded as follows: red: 0.0 to 0.5 keV,
   green: 0.5 to 2.0 keV, blue: 2.0 to 12 keV.

This image :ref:`fig-ex-leg` shows what the pattern of events looks like near zeroth
order.  There are a number of features in this image that are worth
pointing out.  The thick blue line in the middle of the fan-like
structure that extends from the top left of the figure to the bottom
right corresponds to diffracted photons from the primary grating bars
of the LEG.  The events in this line are the subject of the spatial
extraction step when creating the event histograms for spectral
analysis, as described below.  The other blue lines in the fan-like
structure correspond to photons that have also been diffracted by the
fine support structure of the LEG. This fine support structure forms a
grating that diffracts in a direction orthogonal to the primary
diffraction direction.  The events in the multicolored line that runs
from the bottom left to the upper right consists of two contributions.
The first is from photons that arrived at the detector while the image
was being read out between frames.  The second is from the
undiffracted photons from the primary grating that have been
diffracted from the LEG fine support structure. The red star-like
pattern in the center of the figure was produced by photons that have
diffracted from the LEG's coarse support structure, whose 2 mm period
diffracts only the very lowest energy photons through an appreciable
angle.  Finally, if one looks closely enough, the shadowing of the
mirror support struts may be seen near zeroth order.

Analyzing the simulated data
----------------------------

The (type-II) PHA file, grating ARFs and RMFs can be produced using the
standard `CIAO`_ tools using the simulated event file
``letgplaw_evt2.fits`` and the aspect solution file
``letgplaw_asol1.fits`` as inputs. Here is a Bourne shell script that does
this:

.. literalinclude:: letgplaw_ciao.sh
   :language: bash

In particular, this script constructs an order-sorted level 1.5 file from
which plus and minus first order events are extracted, and creates the
corresponding ARFs and RMFs for the extracted spectra.

For this example, we wish to verify that the marx simulation is
consistent with the input spectrum.  To this end, we use `Sherpa`_ to fit
an absorbed powerlaw to the spectrum.  The spectral fits to the
minus first order histograms can be carried out using the
following commands (positive order works similarly):

.. sourceinclude:: sherpafit.py
   :language: python
   :indent: "sherpa> "

	      
This command sequence produced the following parameter values and a reduced
chi-square around 1::

    Reduced statistic     = 1.08292
    Change in statistic   = 2.84957e+07
       a.nH           0
       xp.PhoIndex    1.75727
       xp.norm        0.10434

The reduced chi-squared value indicates that we found an acceptable fit and all
parameter values are close to the original input values (the nH is so small in
the input that the fit may give a zero value as fit result). Note that your
results may vary slightly if you run this example, because |marx| is a
Monte-Carlo simulation based on random numbers.

.. figure:: m1_fit.*
   :align: center
   :alt: Spectrum and best fit.

   Simulated Spectrum in order -1 and a best-fit model.


