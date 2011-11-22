#i jdweb.tm
#i local.tm
#d pagename Creating CIAO-based ARFs and RMFs for MARX Simulations

While \marx strives to accurately model of the Chandra Observatory, there
are some differences that need to be taken into account when
processing \marx generated data with \ciao.  As described on the
\href{caveats.html}{caveats} page, \marx does not incorporate the
non-uniformity maps for the ACIS detector, nor does it employ the
spatially varying CTI-corrected pha redistribution matrices (RMFs).
As such there will be systematic differences between the \marx ACIS
effective area and that of the \mkarf CIAO tool when run in its
default mode.  Similarly, the mapping from energy to pha by \marx will
be different from that predicted by \mkacisrmf.

\hline
\h2{Creating an ARF to match a marx simulation}
\hline

As mentioned above, \marx does not implement the ACIS QE uniformity
maps.  The following \mkarf parameters may be used to produce an ARF
that is consistent with the \marx effective area:
#v+
   mkarf detsubsys="ACIS-7;uniform;bpmask=0" \
         maskfile=NONE pbkfile=NONE dafile=NONE
#v-

An aspect histogram is also required by \mkarf.  The \asphist \ciao
tool may be used to create an aspect histogram from an aspect solution
file.  The \marxasp program may be used to create the aspect solution
file for a dithered marx observation.  See the various examples
for its use.

\hline
\h2{Creating an RMF to match a marx simulation}
\hline

\Marx maps energies to phas using the FEF gaussian parametrization utilized by
the \mkrmf \ciao tool.  The newer \mkacisrmf tool uses a more
complicated convolution model that does not appear to permit a fast,
memory-efficient random number generation algorithm that \marx would
require.  In contrast, a gaussian-distributed random number generator
is all that is required to produce pha values that are consistent with
\mkrmf generated responses.
\p
The \chandra CALDB includes several FEF files.  The one that
\marx{}-\marx-version employs is
\tt{acisD2000-01-29fef_phaN0005.fits}, and is located in
the \tt{$CALDB/data/chandra/acis/cpf/fefs/} directory.  This file must
be specified as the \tt{infile} \mkrmf parameter.
\p
For a point source simulation, look at the \marx2fits generated event
file and find the average chip coordinates.  The \ciao \dmstat tool
may be used for this purpose.  The \tt{CCD_ID} and the mean chip
coordinates are important for the creation of the filter that will be
passed to \mkrmf to select the appropriate FEF tile.  For simplicity
suppose that the mean point source detector location is at (308,494)
on ACIS-7.  Then run \mkrmf using:
#v+
  fef="$CALDB/data/chandra/acis/cpf/fefs/acisD2000-01-29fef_phaN0005.fits"
  mkrmf infile="$fef[ccd_id=7,chipx_hi>=308,chipx_lo<=308,chipy_hi>=494,chipy_lo<=494]"
      axis1="energy=0.25:12.0:0.003" axis2="pi=1:1024:1"
      outfile=marx.rmf
#v-
See the \ciao threads for other ways of running \mkrmf.  The important
thing is to specify the correct FEF and tile.

#i jdweb_end.tm

