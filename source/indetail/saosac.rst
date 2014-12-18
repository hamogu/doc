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
