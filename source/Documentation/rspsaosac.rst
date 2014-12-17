.. _rsp:

Using Response Matrices with |marx|
======================================

The detector models within |marx| include analytic representations of
the intrinsic spectral resolution of these instruments. For some users,
a higher degree of accuracy may be necessary. |marx| allows users to
supersede the built-in spectral response function using an external
spectral response matrix file (RMF). In this section, we describe how to
use the :marxtool:`marxrsp` tool in conjunction with these RMF files.

What is a Response Matrix?
--------------------------

As commonly employed, the spectral response matrix or spectral
redistribution function defines the mapping of input photon energy to
detected pulse height for a given detector. In this sense, it includes
the spectral resolving power of the detector but by definition does
**not** include the quantum efficiency. Typically, these detector
response matrices are stored as response matrix files (RMFs) in the form
of FITS binary tables.

The format for an RMF has been defined by HEASARC and :marxtool:`marxrsp` has been
designed to work with RMFs which adhere to this format. Specifically,
the :marxtool:`marxrsp` tool checks the indicated RMF file for valid values of the
HDUCLAS3 FITS keyword. HEASARC-allowed values for this keyword include
``REDIST``, ``DETECTOR``, or ``FULL``. A value of ``REDIST`` indicates a bare
redistribution matrix while ``DETECTOR`` and ``FULL`` indicate that a quantum
efficiency or effective area have been included, respectively. The
:marxtool:`marxrsp` tool requires a value of ``HDUCLAS3=REDIST``. The ``--force`` option
can be used to make :marxtool:`marxrsp` accept RMF files with other values of the
HDUCLAS3 keyword. In such circumstances, the input marx simulation
should be run with :par:`DetIdeal="yes"`.

Response matrices for the ACIS CCDs can be created using the `CIAO`_ tool
:ciao:`mkrmf`. More information and the necessary calibration data to create
ACIS RMFs are available from the `CIAO`_. There are currently no
RMFs available for the HRC.

.. figure:: fig_rmf.*
   :align: center
   :name: figrmf
   
   A simulated ACIS pulse height spectrum computed using a marx simulation, the
   :marxtool:`marxrsp` tool, and RMF files for a FI and BI CCD. The upper curve shows the PHA spectrum
   for the BI RMF while the lower curve represents a typical FI RMF near the ACIS-I aimpoint.
   The input spectrum was the same thermal plasma spectrum used in the examples in :ref:`samplemarxsimulations`.




The marxrsp Tool
----------------

Like all post-processing tools in the |marx| suite, :marxtool:`marxrsp` operates
on an existing simulation directory created using marx. The user
specifies a simulation directory and an RMF to use in calculating the
pulse height spectrum. For example, to fold the Raymond-Smith thermal
plasma spectrum simulated in Section [chap:examples] through an ACIS RMF
called ``acis7b_aim_pha_rmf.fits``, we would use the syntax::

    unix% marxrsp --rmf acis7b_aim_pha_rmf.fits --marx therm/

Here, the pre-existing simulation directory is called therm.
Operationally, marxrsp will check the indicated RMF for a valid HDUCLAS3
keyword value. If ``HDUCLAS3=REDIST``, :marxtool:`marxrsp` will read the ``energy.dat``
binary vector from the simulation directory and multiply it by the
values in the RMF to determine the event pulse heights or PHA values. A
new ``pha.dat`` binary vector will then be written back out to the
|marx| simulation directory. The old ``pha.dat`` file, containing the
pulse height spectrum calculated using |marx|’s internal
redistribution function, will be renamed to ``pha.dat.BAK``.
Figure `figrmf`_ shows the pulse height spectra obtained from folding
the thermal spectrum simulation from  :ref:`samplemarxsimulations` through
RMFs for an ACIS frontside and backside illuminated CCD.

By default, marxrsp will process all events in the specified simulation
directory. Users may restrict which photons are folded through the RMF
using the ``--chip`` parameter. For example, the command

::

    unix% marxrsp --chip 7 --rmf acis7b_aim_pha_rmf.fits --marx therm/

would calculate pulse heights for only those events which landed on chip
7 (the aimpoint of the ACIS-S array) in the calculation of the pulse
height spectrum.  See :marxtool:`marxrsp` for a detailed
description of all options.


Note, marxrsp cannot be used to process the output products of the
:marxtool:`marxpileup` tool. marxrsp uses the binary output vector ``energy.dat`` to compute
the new PHA value for an event. However, the events produced by the
pileup tool are potentially the sum of multiple photons and therefore
their true energies are unknown.

Limitations of the marxrsp tool
-------------------------------

Due to spatial variations in the gain across the ACIS CCDs, the detected
PHA value of an event will vary even for monochromatic photons. This
variation is illustrated in Figure `Gain`_ which shows the PHA
spectra obtained for the S3 and I3 ACIS CCDs from a uniform illumination
of 1.0 keV photons. During CXC Level 1 processing, the known calibration
of the gain is used to correct the PHA values and produce a list of
"pulse invariant" (PI) detector channels. These PI values are
essentially uniformly binned energy values with bins of 14.6 eV.
|marx| emulates this behavior in :marxtool:`marx2fits` by using the same ACIS gain
map as the CXC Level 1 pipeline. However, processing a simulation with
:marxtool:`marxrsp` is equivalent to replacing the actual spatially varying gains
with whatever uniform value was used in the construction of the RMF. If
a simulation which has been folded though an RMF file with :marxtool:`marxrsp` is
subsequently written to a Level 1 FITS events with :marxtool:`marx2fits`, the PI
values in the file event file will be incorrect. **Consequently, if
using marxrsp, users should perform all spectral extractions and data
analysis in PHA space.**

.. figure:: fig_gain.*
   :align: center
   :name: Gain

   The PHA spectra obtained for simulations of the S3 and I3 ACIS CCDs from a
   uniform illumination of 1.0 keV photons. The upper curve shows the PHA spectrum for the
   S3 while the lower curve represents I3. Both spectra have been normalized to the same total
   number of counts.



.. _saosac:

Using |marx| with SAOSAC
==========================

.. warning:: Out of date.

   Some information in section might be out of date. It will be rewritten soon.

For calibration purposes, the Mission Support Team (MST) has developed
an extremely high-fidelity raytrace of the HRMA onboard Chandra called
SAOSAC. SAOSAC is the definitive CXC mirror model and includes many of
the details of the HRMA’s physical construction such as the stray light
baffles and support structures as well as a detailed model of the
reflective properties of the mirror surface. Using XRCF and, ultimately,
on-orbit calibration data, SAOSAC will be "tuned" to reproduce actual
HRMA performance to a high degree of accuracy. SAOSAC serves as baseline
for the HRMA model contained within |marx|. In fact, the |marx| HRMA
model is a simplified version of SAOSAC and includes as many of SAOSAC’s
features as can be reasonably be reproduced while still maintaining
|marx| 's speed and portability.

Using SAOSAC Rayfiles in |marx|
----------------------------------

For many purposes, the HRMA model within |marx| will be sufficiently
accurate. However, users wishing to study very subtle effects caused by
fine details in the HRMA may wish to run simulations utilizing the
SAOSAC mirror model. Users involved in analysis of calibration data are
one obvious example. In such a situation, the user might wish to use
SAOSAC in combination with the detector models or grating models
available within |marx|. The |marx| package provides this capability
by ingesting SAOSAC FITS format rayfiles.

At the current time, it is not planned to distribute the SAOSAC mirror
model to the user community. Instead, SAOSAC rayfiles will be
pre-computed and distributed as needed. These rayfiles take the form of
FITS files containing binary tables of photon or "ray" properties. In
order to provide users with the option of using the SAOSAC mirror model,
|marx| is capable of ingesting standard SAOSAC FITS rayfiles.

The interface to SAOSAC rayfiles is implemented in |marx| by setting
the value of the :par:`SourceType` parameter to ``SAOSAC``. The path to the
SAOSAC rayfile to be accessed is specified using the :par:`SAOSACFile`
parameter. For example, if we wanted to run a |marx| simulation of the
HSI first light test at XRCF, we might use a command similar to:

::

    unix% marx SourceType="SAOSAC" SAOSACFile="C-IXH-PI-3.001.fits"

where C-IXH-PI-3.001.fits in this case is the rayfile appropriate for
that test. 

.. figure:: fig_saosac.*
   :align: center

   The distribution of focal plane photon positions for a |marx| simulation created
   using an SAOSAC FITS rayfile. This rayfile corresponds to XRCF test ID C-IXH-PI-3.001 and
   contains 10000 rays. The XRCF test in question was performed with the HRMA 5.0 mm out of
   focus and this defocus value is reproduced in the simulation.

   


In |marx| 4.0, an option for "colorizing" SAOSAC rays has been added.
If the parameter :par:`SAOSAC_Color_Rays=yes`, then photon energies and
arrival times for each SAOSAC ray processed will be determined based on
the status of the :par:`SpectrumType` parameter. Note that since SAOSAC
rayfiles are typically calculated for monochromatic energies, this
option could lead to inaccuracies over large energy ranges. For narrow
energy bands, such as in the vicinity of a bright emission line, this
scaling should be reasonably accurate. If the SAOSAC rayfile contains
event arrival times and :par:`SAOSAC_Color_Rays=no`, then |marx| will use
the values in the rayfile. In the absence of specified arrival times or
colorizing, |marx| assigns incremental 1 sec arrival times to each
detected event.

Using |marx| Rayfiles in SAOSAC
---------------------------------

One of the limitations of the SAOSAC model at present is its inability
to model polychromatic sources. Such sources must currently be modeled
by forming weighted sums of a set of monochromatic simulations.
|marx|  provides an alternative to this approach. Using the :marxtool:`marx2dpde`
tool, |marx| simulations can be translated into DPDE format suitable
for further processing using any tools or pipelines built to handle this
SAOSAC output format. The DPDE format is a binary rayfile format which
was the precursor to the current FITS standard. A number of tools
including the Calibration group’s ACIS simulator were designed to work
with these files.

To create a DPDE file from the results of a |marx| simulation, one
might use the following command:

::

    unix% marx2dpde saosac-sim/ saosac-sim.dpde

The resulting DPDE file can then be processed by additional tools as
desired. The :marxtool:`marx2dpde` tool can also be used to examine the contents of
an SAOSAC DPDE file with:

::

    unix% marx2dpde --dump saosac-sim.dpde > saosac-sim.out

By default, ``marx2dpde --dump`` sends its output to the standard output.
Here we have piped that output into an ASCII file.

Note, according to the MST, the SAOSAC DPDE format is being phased out
in favor of the FITS rayfile standard discussed in the previous section.
