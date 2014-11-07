******************************************************
Creating CIAO-based ARFs and RMFs for MARX Simulations
******************************************************

While |marx| strives to accurately model of the Chandra Observatory, there
are some differences that need to be taken into account when
processing |marx| generated data with `CIAO`_.  As described in :ref:`caveats`
page, |marx| does not incorporate the
non-uniformity maps for the ACIS detector, nor does it employ the
spatially varying CTI-corrected pha redistribution matrices (RMFs).
As such there will be systematic differences between the \marx ACIS
effective area and that of the :ciao:`mkarf` CIAO tool when run in its
default mode.  Similarly, the mapping from energy to pha by |marx| will
be different from that predicted by :ciao:`mkacisrmf`.


Creating an ARF to match a marx simulation
==========================================

As mentioned above, |marx| does not implement the ACIS QE uniformity
maps.  The following \mkarf parameters may be used to produce an ARF
that is consistent with the |marx| effective area::

   mkarf detsubsys="ACIS-7;uniform;bpmask=0" \
         maskfile=NONE pbkfile=NONE dafile=NONE

An aspect histogram is also required by :ciao:`mkarf`.  The :ciao:`asphist` CIAO
tool may be used to create an aspect histogram from an aspect solution
file.  The :marxtool:`marxasp` program may be used to create the aspect solution
file for a dithered marx observation.  See the various examples
for its use.


Creating an RMF to match a marx simulation
==========================================
|marx| maps energies to phas using the FEF gaussian parametrization utilized by
the :ciao:`mkrmf` CIAO tool.  The newer :ciao:`mkacisrmf` tool uses a more
complicated convolution model that does not appear to permit a fast,
memory-efficient random number generation algorithm that |marx| would
require.  In contrast, a gaussian-distributed random number generator
is all that is required to produce pha values that are consistent with
:ciao:`mkrmf` generated responses.

The Chandra CALDB includes several FEF files.  The one that
|marx| currently employs is
``acisD2000-01-29fef_phaN0005.fits``, and is located in
the ``$CALDB/data/chandra/acis/cpf/fefs/`` directory.  This file must
be specified as the ``infile`` :ciao:`mkrmf` parameter.

For a point source simulation, look at the :marxtool:`marx2fits` generated event
file and find the average chip coordinates.  The CIAO :ciao:`dmstat` tool
may be used for this purpose.  The ``CCD_ID`` and the mean chip
coordinates are important for the creation of the filter that will be
passed to :ciao:`mkrmf` to select the appropriate FEF tile.  For simplicity
suppose that the mean point source detector location is at (308,494)
on ACIS-7.  Then run :ciao:`mkrmf` using::

  fef="$CALDB/data/chandra/acis/cpf/fefs/acisD2000-01-29fef_phaN0005.fits"
  mkrmf infile="$fef[ccd_id=7,chipx_hi>=308,chipx_lo<=308,chipy_hi>=494,chipy_lo<=494]"
      axis1="energy=0.25:12.0:0.003" axis2="pi=1:1024:1"
      outfile=marx.rmf

See the `CIAO`_ threads for other ways of running :ciao:`mkrmf`.  The important
thing is to specify the correct FEF and tile.

