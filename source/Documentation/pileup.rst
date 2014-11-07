.. _pileup:

Simulating ACIS Pileup with |marx|
==================================

    Confusion is a word we have invented for an order which is not
    understood.

       – Henry Miller

Introduction
------------

In this section, we will discuss how to use the :marxtool:`pileup` tool in
|marx| to simulate the effects on Chandra data of photon pileup in the
ACIS CCDs. As a post-processing module, the :marxtool:`pileup` tool is designed to
work with existing |marx| simulations. Users first create a simulation
using marx :ref:`running` and then, if necessary, run
pileup on the results of that simulation to study pileup effects. In
this manner, users simulating faint or extended sources which are less
susceptible to pileup can produce |marx| simulations more quickly. We
will briefly describe the pileup process itself and then proceed to
outline the use and output of the pileup tool.

What is ACIS Pileup?
--------------------

At some level, all Chandra observations performed with the ACIS imager
will suffer from the effects of pileup. Pileup occurs when two or more
photons land in the same pixel location in a given ACIS readout time. In
this situation, ACIS "detects" a single photon with an energy which is
roughly the sum of the two component photons. Some simple schematic
representations of such "piled" photons are shown  below. The
pileup process can affect ACIS data in a number of ways including:

**Photometric Inaccuracy**
   The event detection algorithm cannot distinguish between single,
   large pulse height events and composite, piled events. Consequently,
   the detected count rate will be reduced with respect to the true
   count rate in the absence of pileup.

**Spectral Distortion**
   By combining multiple incident, photons into a single "detected"
   event with a larger pulse height, pileup effectively "hardens" the
   observed ACIS spectrum.

**Point Spread Function Distortion**
   The severity of the pileup effect is governed in part by event
   density. Since the core of the PSF has a higher event density than
   the wings, it will be affected to a greater degree. This effect will
   tend to broaden the PSF as the ratio of core to wing events
   decreases.

**Grade Migration**
   As the degree of pileup increases, the distribution of event grades
   will change. Multiple photon or "piled" events will tend to have
   "bad" grades which include detached corner pixels, such as ASCA
   grades 1,5, and 7. This migration will have repercussions for
   standard data analysis which often begins by discarding such "bad"
   grades.

+-------------------------------------------------+-------------------------+
| .. image:: evt_phot1.*                          | .. image:: evt_total.*  |
|    :height: 150                                 |    :height: 300         |
|    :align: center                               |                         |
|                                                 |                         |
| .. image:: evt_phot2.*                          |                         |
|    :height: 150                                 |                         |
|    :align: center                               |                         |
+-------------------------------------------------+-------------------------+
| A schematic representation of a  "piled"  event. In this simple           |
| illustration, two events are detected in the same location within an      |
| ACIS frametime. The left top panel shows the 3x3 pixel pattern of pulse   |
| heights the first incident photon generates on its own and the left       |
| bottom panel shows the pattern for the second, individual incident        |
| photon. Finally, the right  panel shows the composite,  "piled"  pulse    |
| height pattern which would actually be detected. The pulse heights are    |
| shown here in units of keV. Note that the magnitude of the  "piled"       |
| distribution is essentially the sum of the two component                  |
| distributions. Hence, instead of detecting two roughly 3 keV photons,     |
| we would have detected a single 6 keV photon.                             |
+---------------------------------------------------------------------------+

.. figure:: evt_grid.*
   :name: evtsplit
   :alt: Schematic representation of a  "split"  event
   :align: center

   A schematic representation of a small portion (8x8 pixels
   square) of a CCD in which two events have been detected.
   The highest amplitude event (indicated by an X) is the pixel
   of interest. Since the standard event-detection routine classifies
   events in a 3x3 square pixel neighborhood, rates in all other pixels
   marked with an X must also be considered. In addition, some events
   two pixels away, like the one marked with an O, could pile via
   splitting onto the event of interest. In this example, both events
   have been shown as split - the X event to the right, and the
   O event to the left. The X event would be assigned too much
   charge, in this case. Thus, the rates in pixels marked with a +
   must be considered when assessing the pileup rate in event X (but
   not all events in this border will actually pile with event X; the
   actual number depends on the details of the branching ratios into each
   grade).


Chandra observations of bright point sources are the most likely to be
significantly affected by pileup. Extended or faint sources will be less
affected although sharp features such as unresolved cores or bright
knots or filaments could still be vulnerable. Although pileup cannot be
avoided entirely, a number of techniques can be employed to mitigate its
effects somewhat. For a more detailed discussion of pileup, the reader
is referred to :ciao:`acis_pileup`.

Overview of the pileup Tool
---------------------------

The :marxtool:`pileup` tool implements the pileup algorithm developed by John Davis
(MIT). This same algorithm has been implemented into the `ISIS`_,
`SHERPA`_, and `XSPEC`_ spectral fitting packages. While this implementation
of the pileup algorithm emulates most of the qualitative effects of ACIS
photon pileup, users should keep in mind that we are still calibrating
the procedure. The ACIS pileup model is statistical and is not an a
priori photon-silicon interaction model which generates charge clouds
and then PHAs per event "island." The model is valid on-axis for point
sources for low to moderate pileup. While valid for **qualitative**
predictions of the effects of pileup on the PSF, it has not been
verified for image reconstruction. Detailed studies of the effects of
pileup on the HRMA PSF including comparisons to actual on-orbit data are
still underway. The model is very good for spectral modeling of light to
moderately piled point sources. Users should interpret all results
including the effects of pileup cautiously.
