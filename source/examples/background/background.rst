.. _sect-ex-bkg:

Including background in a |marx| simulation
===========================================

The data from all Chandra observations includes different background
components: Astrophysical background (e.g. unresolved sources), instrumental
background (e.g. high-energy particles from the sun), and a read-out artifact.
The `Proposers Observatory Guide
<http://cxc.harvard.edu/proposer/POG/html/chap6.html#tth_sEc6.16>`_ describes
all these components in detail.

The background matters most for faint or extended sources. In this
example we show two different methods to include a background component into a
|marx| simulation. Because |marx| ray-traces X-ray photons and does not
calculate the interaction between spacecraft components and energetic
particles, both methods need to make approximations:

#. The Chandra calibration team has released "blank sky background" files for the ACIS
   detector. :ref:`subsect-ex-bkg-blanksky` shows how to add observed background
   events from these files to a |marx| simulation. This should provide the most
   realistic background, but there are several caveats:

   * As described in :ref:`caveats`, |marx| does not incorporate the
     non-uniformity maps for the ACIS detector, nor does it employ the spatially
     varying CTI-corrected pha redistribution matrices (RMFs). As such there
     always will be systematic differences between the simulated MARX source and
     the real background data.
   * The "blank sky" files contain between a 30,000 and a few million photons
     (depending on the chip). If this procedure is repeated for many |marx|
     simulations, it adds photons *from the same pool* every time, so this cannot
     be used for a statistical analysis if the total number of background photons
     approaches the number of photons in the file.

#. We extract fit the apparent spectrum of the "blank sky" files ("apparent"
   because the events look like X-ray photons on the CCD, but in reality many are electron
   or proton impacts) and then use |marx| to simulate an extended source that
   produces a similar spectrum (:ref:`subsect-ex-bkg-marxbkg`). This approach is
   easier and faster, but it does  not capture all details of the `spatial
   variations of the background 
   <http://cxc.harvard.edu/cal/Acis/Cal_prods/bkgrnd/nonuniformity/acisbg.html>`_.

.. warning:: Background is time variable!

   The background count rate can vary within minutes in so-called flares (`example for a background
   lightcurve <http://cxc.harvard.edu/proposer/POG/html/chap6.html#tth_sEc6.16.3>`_),
   and even the quiescent background level changes over time.
   Thus, the simulation can only give a prediction of a *typical* background. The actual
   background might turn out to be higher or lower.

.. warning:: Sky background depends on Ra, Dec!

   See e.g. `Markevitch (2002) <http://arxiv.org/pdf/astro-ph/0205333v1.pdf>`_
   for a comparison of Chandra and XMM-Newton data of the same galaxy cluster,
   where the fitted temperature strongly depends on the background model and
   the Chandra "blank sky" files underpredict the background flux.


Simulating the source: A diffuse, thermal emission
--------------------------------------------------

In this example, we model a diffuse
emission region with a cool, thermal plasma as they are often seen in massive
star forming regions. For the purposes of this example, we do not model the
stars themselves, which would show up as additional point sources. We chose a
relatively simple model with one thermal emission component in collisional
ionization equilibrium with parameters similar to those observed by `Güdel et. al
(2008) <http://adsabs.harvard.edu/abs/2008Sci...319..309G>`_ in Orion.

.. figure:: carina.*
   :align: center
   :alt: The Carina Nebula contains 14,000 point sources and significant
       diffuse emission.
   :scale: 75%
   :target: http://chandra.harvard.edu/photo/2011/carina/

   X-rays in the Carina Nebula

   Point sources and diffuse emission in the Carina Nebula, yet another star
   forming region with diffuse emission. The image is a composite from several
   Chandra observations. `Townsley et
   al. (2011) <http://adsabs.harvard.edu/abs/2011ApJS..194...15T>`_ 
   fit the diffuse emission with a complex model of 6 components, most of which
   are thermal plasmas.

   Image credit: NASA/CXC/PSU/L.Townsley et al.

Similar to :ref:`creating_sherpa_spectrum` we will use `Sherpa`_ to create a 
2-column text file that tabulates the flux density [photons/sec/keV/cm^2] (second
column) as a function of energy [keV] (first column).

.. sourceinclude:: spectralmodel.py
   :indent: "sherpa> "
   :language: python 

More details about the format of the |marx| input spectrum can be found at
:par:`SpectrumFile`. 

The next step is to run |marx| in the desired configuration:

.. literalinclude:: runmarx.inc
   :language: bash

The :par:`SourceFlux` sets the observed photon flux by renormalizing the input
spectrum. For the shape of the source we choose a Gaussian that is more than one
arcmin wide and we set the aimpoint on the back-illuminated ACIS-S3 chip (chip ID 7). The results of the
simulation will be written to a subdirectory called ``diffuse``, as
specified by the :par:`OutputDir` parameter.  After the simulation has
completed, a standard Chandra event file may be created using the
:marxtool:`marx2fits` program:

.. literalinclude:: runmarx2fits.inc
   :language: bash

We also generate an aspect solution file that matches the simulation:

.. literalinclude:: runmarxasp.inc
   :language: bash

.. _subsect-ex-bkg-blanksky:

Adding "blank-sky background" to a |marx| simulation
----------------------------------------------------
The "blank sky background" files are part of 
`CalDB`_ but because of their size
they are not installed by default. If you don't have them yet, use the
`ciao-install script <http://cxc.harvard.edu/ciao/download/>`_ or download them
by hand from http://cxc.harvard.edu/ciao/download/caldb.html . |marx| does not
simulate all physical effects in Chandra (see :ref:`caveats`) and thus none of
the "blank sky background" files matches the way that |marx| generates the data
exactly. In particular, |marx| does not apply the CTI correction, thus we will
use the "blank sky background" files that do not have ``_cti`` in their
filename. The naming convention is
``acis<chip><aimpoint>D<date>bkgrndN<version>.fits``. 

In this simulation we care for chip-ID 7 and the ACIS-S aimpoint, so we select
the most recent background file and copy it to the working directory:

.. literalinclude:: copycaldbbkg.sh
   :language: bash

We now need to do some fiddleing with the |marx| simulation and the background
file to make their formats compatible so that we can eventually merge them into
a single event file. This involves the following steps:

#. Select a random subset of photons in the "blank sky file". We need to

    - Find the number of rows in that file (header keyword ``NAXIS2``).
    - Estimate the number of background photons we want to simulate.
      Looking at `the appropriate table in the Observatory Guide 
      <http://cxc.harvard.edu/proposer/POG/html/chap6.html#tth_sEc6.16.2>`_
      we see that roughly 0.3 cts/s (in the event grades we care for) is a good,
      conservative estiamte. For an observation of 100 ks, we thus decide to
      select roughly 30,000 photons.
    - Events in the "blank sky" files are sorted in x and y. In order to
      select a random subset, we use :ciao:`dmtcalc` to assign a random number
      in column ``randnum`` and multiply it with the ratio of the number of
      photons in the "blank sky" file and the number of photons we
      want to select.
    - We copy only those photons where the ratio is smaller than 1. Since this
      involves a random number, this also introduces a "random error" to the
      number of photons we select - it will not be exactly 30,000. 
 
#. Add a time column to the "blank sky" file and fill it with random values
   during the observation.
#. Reproject the "blank sky" file to the observed position on the sky.
#. Select the same columns in the |marx| simulation and the "blank sky" file, so
   that they can be merged with :ciao:`dmmerge`.

Here is the script that we use:

.. literalinclude:: mergebkg.sh
   :language: bash

If the source in the simulation covers multiple ACIS chips, then this
has to be repeated chip-by-chip. 

.. _fig-ex-bkg:

.. figure:: bkg.*
   :align: center
   :alt: Images of three event files. See caption for a description.

   Images of event files

   *left:* Image of the |marx| simulation alone. The source is extended and not
   very strong. *center:* Background added to the simulation. The source is
   not visible any longer, because the background totally domiantes the count
   rate. *right:* We know that our source is fairly soft, while the background
   contains a lot of high-energy events. Thus, we can apply an energy filter
   (here 0.2-2.0 keV) that focusses on the energy range where the source is
   strongest relative to the background. A slight overdensity of photons can
   be seen at the position of the source, but it will be very difficult to fit
   spectral parameters or to determine the radius of the source accurately.

The figure :ref:`fig-ex-bkg` shows the |marx| simulation alone, with added
background from the "blank sky" file and with an energy filter that we would
probably use for real data to suppresses some of the background.

Looking at the background-free |marx| simulation, measuring the flux and the
size of this source seems like an easy task. When properly including background
the source can still be detected, but fitted source parameters will be more
uncertain than they would be in a background-free scenario. This example shows
how important it is to consider the instrumental background when simulating weak sources.

.. _subsect-ex-bkg-marxbkg:

Simulating a background-like source with |marx|
-----------------------------------------------
An alternative approach is to extract a spectrum from the "black-sky" fields 
and use this spectrum as input for |marx|. This spectrum does **not**
describe the real *physical properties* such as the energy of the background events 
(many of them are not even photons), it just provides an effective way
to simulate "something that looks similar to real background when run through
|marx|". 

The advantage of this approach is that we can generate more random events
than the original "blank-sky" file has without repeating photons.

First, extract a spectrum from the "blank-sky" background and save this
spectrum in a table that |marx| can read. This can be done
with the following commands (a detailed explanation for this is at 
http://cxc.harvard.edu/ciao/threads/extended/ ):

.. literalinclude:: extract_blanksky.sh
   :language: bash

We use `Sherpa`_ to display the spectrum on the screen (see
:ref:`fig-ex-blankskyspectrum`) and save it in a table
with columns energy and count rate density (see :par:`SpectrumFile` for details
of the input spectrum format for |marx|):

.. sourceinclude:: blank_sky.py
   :indent: "sherpa> "
   :language: python 

.. _fig-ex-blankskyspectrum:

.. figure:: extracted_bkgspec.*
   :alt: Mostly flat spectrum, rising at large energies. There are a few
       emission features on top of the spectrum.
   :align: center

   Extracted "blank-sky" spectrum.


Again, we want a source flux of about 0.3 counts/s over the entire detector. 
:par:`SourceFlux` expects the flux in counts/s/cm^2, so we would have to devide
by *Chandra*'s effective area. Alternatively, we can just set the
exact number of photons we want to detect with :par:`ExposureTime=0` and :par:`NumRays`
set to a negative number. We set :par:`SpectrumFile` to the spectrum of
the background. Now we only need to specify the shape of the
source. Figure :ref:`fig-ex-bkgonchip` shows regions with higher or
lower background level in the input "blank sky" file.

.. literalinclude:: dmcopy.sh
   :language: bash

.. _fig-ex-bkgonchip:

.. figure:: chip-shape.*
   :align: center
   :alt: Image with rough blocks almost like a checkerboard, but with very little contrast.

   Binned "blank sky" file for chip 7

To reproduce this pattern, we use |marx| with :par:`SourceType="IMAGE"`. 
There is a trade-off here: If we bin the image too much, we smooth out the
structure, if we bin too little such that we still see the random noise in the
image, then our |marx| simulation will produce an event distribution that shows
the same "random noise pattern". That fine, unless we want to run many |marx|
simulations, where we would see the same "random" pattern again and again. Here, the
binning is chosen such that we find a few thousand events in every pixel of the
image.

All remaining |marx| parameters (:par:`RA_Nom`, :par:`Dec_Nom` etc.) are the
same as in the simulation of the astrophysical source of interest above.

.. literalinclude:: marx4bkg.sh
   :language: bash

Now, we can use :marxtool:`marxcat` to merge the simulation of the diffuse
source and the background and :marxtool:`marx2fits` to convert the merged
results into a fits file.

.. literalinclude:: marxcat.sh
   :language: bash

.. _fig-ex-bkg2:

.. figure:: bkg2.*
   :align: center
   :alt: Images of three event files. See caption for a description.

   Images of the event files with |marx| simulated background

   This figure has the same panels as :ref:`fig-ex-bkg2`, except that the background is
   simulated with |marx| instead of taking photons directly from the "blank
   sky" file.

Looking at :ref:`fig-ex-bkg2` we again see that the background makes it much
harder to discern the source. The images look very similar to
:ref:`fig-ex-bkg`, indicating that both approaches to describe the background
give similar results. The main difference is that in the |marx| simulation the
edge of the chip is more fuzzy. That's because pixel boundaries in
:ref:`fig-ex-bkgonchip` do not coincide exactly with the chip
boundaries and thus we simulate the "background" for a region slightly larger
than the chip. However, this is not important for our purpose: Finding how well we
can fit the source position, size and spectrum in the presence of background.


Notes about additional background components
--------------------------------------------
In addition to the instrumental background, there is
also an astrophyiscal background. This can be unrelated to the target of the
observation, such as charge exchange emission in the solar wind or the
population of weak background AGN, that is roughly homogeneous over the
field-of-view and contributes to the observed "diffuse" background.

For some targets, there are additional contributions to the apparent background
that are related to the source. For example, in the case of diffuse emission in a star
forming region there will be stars in the cluster. While the bright stars
should be detected as point sources and those regions can be excluded from the
analysis, there might be a population of weak stars that contribute only a few
photons each, but add up to provide significant flux in addition to a truly
diffuse component from a hot gas.

Different strategies can be used to account for those backgrounds in spectral
modeling, but that is beyond the scope of this |marx| example.
