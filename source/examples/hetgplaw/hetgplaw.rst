.. _sect-ex-HETG-disk:

HETG simulation of an extended source
=====================================

The purpose of this example, contributed by
`Dan Dewey <http://space.mit.edu/home/dd/>`_, is to show how to use
|marx| to simulate an HETG observation of a point and a
simple extended source with a user-specified spectrum. This example, like many
of the other examples, uses |marx|, `ISIS`_ and `CIAO`_, which should be 
installed on your system to run this example. 

Create the spectral file
------------------------

Use MARX to simulate an HETG observation of a powerlaw with two added lines
(For example, this could be Fe and Ne flourescence lines).
We will use `ISIS`_ to create a file :download:`plaw_hetg.par` which describes this
spectral model.
This is similar to :ref:`sect-ex-ACISCCD` except that the source is brighter
and has a less steep powerlaw.

.. sourceinclude:: isismodel.sl
   :indent: "isis> "

Now, use :marxtool:`marxflux` to evaluate the ``plaw_hetg.par`` file to create a |marx| spectrum file.
Here a fine binning is used having bins with dE/E = 0.0003 (v_bin = 90 km/s).
This gives a high resolution spectrum across the whole 1 to 40 A
(0.31 to 12.4 keV) range suitable for use with the HETG as well as, e.g.,
future microcalorimeter instruments.

.. literalinclude:: run_marxflux.inc
   :language: bash

The file :download:`plawflux_hetg.tbl` can now be used by |marx| to define the spectrum.

Setup and run |marx|
--------------------
Roughly these steps are the same as for the previous examples, except that
the HETG is inserted by using :par:`GratingType="HETG"`.

It can be convenient to use :marxtool:`pset` to set the parameters in a
local par file, so that method is demonstrated and used here.

Set up the various marx parameters as desired.  Note that
you can edit and re-do the following lines for new
or modified simulations.  As an example, the first simulation
here is for a :ref:`sect-models-POINT`; it is followed by a few additional
lines to do a second simulation with a :ref:`sect-models-DISK`.

In the working directory paste these sets of lines to the unix prompt to run
a first simulation using a point source:

.. literalinclude:: run_marx_point.inc
   :language: bash

|marx| runs, ending with something similar to (since |marx| is a Monte-Carlo
based simulation, the exact number of detected photons can vary)::

   Writing output to directory 'hetg_plaw' ...
   Total photons: 3495031, Total Photons detected: 255172, (efficiency: 0.073010)
     (efficiency this iteration  0.073986)  Total time: 50000.000492

.. code-block:: bash

    # Create the fits event file and the aspect solution file:
    marx2fits hetg_plaw hetg_plaw_evt2.fits
    marxasp MarxDir="hetg_plaw" OutputFile="hetg_plaw_asol1.fits"

Now, do another simulation keeping most things the same as above
by starting with the ``mysim.par`` as it is left from above
but changing a few things to use a :ref:`sect-models-DISK`:

.. literalinclude:: run_marx_disk.inc
   :language: bash

Next, we create the fits event file and the aspect solution files for both
simulations:

.. literalinclude:: run_marx2fits.inc
   :language: bash

.. note:: Combining |marx| simulations

    The tool :marxtool:`marxcat` allows simulations to be combined, e.g., we
    could do the following to make a combination of the point and disk events::

        marxcat hetg_plaw hetg_pldisk hetg_plboth

    and then create fits and asol files as above.
    This allows more complex spatial-spectral simulations to be done with |marx|.


We can look at the simulation output event files with `ds9`_ to check that they
are as expected before continuuing with ciao-processing. Figure
:ref:`fig-ex-hetgplaw` shows both simulations.

.. _fig-ex-hetgplaw:

.. figure:: hetg.*
   :alt: ds9 image of two event files, described in the caption
   :align: center

   Event files from both |marx| simulations

   The simulation of the point source is shown on the top, the extended source
   on the bottom. The extended source has a much wider zeroth order, but the
   scaling of the image is chosen to bring out the faint features so this is
   hard to see. Above and below the zeroth order the read-out streak is
   visible. In both images the X-shape of the grating spectra can be seen. The
   spectra are much wider in the bottom image due to the source
   extension. Still, the grating extraction area (green outlines) is large
   enough to capture most of the signal.
   
We can also use `ds9`_ to record the center of the
disk (simulation 2) in X,Y coordinates (4096.5, 4096.5) for further processing.


Extract HETG spectra
--------------------
We will extract the HETG spectra and then calculate the response matrix
for the positive and negative first order in the MEG grating. There is very
little signal in the higher orders, so they would not help to constrain the fit
significantly. Extraction of the HEG grating works in a similar way, see the
`CIAO`_ documentation for details.

.. literalinclude:: hetg_ciao.sh
   :language: bash

Perform spectral analysis
-------------------------
As an examples of the spectra analysis, we will fit an absorbed powerlaw to the
point-like source spectrum. The spectral regions where the extra lines are
located are ignored in the fit. Fitting the spectrum of the extended source
works in the similar way. Naturally, a lot more analysis could be done on the
simulated spectra, the most obvious point might be a fit of the spectral lines
to determine the spectral resolution of Chandra in this example. (The lines from
the extended source will appear much wider.) However, that is beyond the scope
of this example. Please check the manual of your preferred X-ray spectral
fitting software. In this example below, we use `ISIS`_, but `XSPEC`_ and
`Sherpa`_ work very similar.

This is `ISIS`_ code to fit an absorbed powerlaw to the simulated spectrum:

.. sourceinclude:: isisfit.sl
   :indent: "isis> "

The resulting fit parameters are similar, but not identical, to the
parameters we put into the simulation above.

.. figure:: hetgmeg1.*
   :alt: Spectra in count space.
   :align: center

   Simulated spectra for MEG order +1 and -1

   The MEG orders are shown as the red and orange line. They differ from
   one another because the effective area is different, e.g. the gaps between
   the ACIS chips fall on different wavelengths. The blue line is the best fit
   model for the spectrum shown in red.
