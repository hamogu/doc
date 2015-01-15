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
   The input spectrum was the same thermal plasma spectrum used in the examples in :ref:`sect-ex-ACISCCD`.




The marxrsp Tool
----------------

Like all post-processing tools in the |marx| suite, :marxtool:`marxrsp` operates
on an existing simulation directory created using marx. The user
specifies a simulation directory and an RMF to use in calculating the
pulse height spectrum. For example, to fold the Raymond-Smith thermal
plasma spectrum simulated in :ref:`sect-ex-ACISCCD` through an ACIS RMF
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
the thermal spectrum simulation from  :ref:`sect-ex-ACISCCD` through
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

