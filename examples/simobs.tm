#i jdweb.tm
#i local.tm
#d pagename Simulating a Chandra Observation with Marx

#d file#1 \href{powerlaw/$1}{$1}

The example presented here was originally designed to see how well the
\marx PSF compares to that of an actual Chandra observation of a far
off-axis source.  We will also be comparing the \marx intrinsic PSF to
that of \saotrace.  Hence, this example will serve several purposes:

\ul{
\item How to simulate an existing observation.
\item How to use \saotrace dithered rays with \marx.
\item To see how the \saotrace and \marx PSFs compare to the observed
PSF for a far off-axis source.
}

In this example, we will use the 1999 Chandra calibration observation
of LMC X-1 observed about 25 arc-minutes off-axis with the ACIS
detector (ObsID 1068).

It is assumed that the data for obsid 1068 has been downloaded
from the archive and reprocessed it with the latest version of \ciao
to produce a level-2 file.  Here is the image of the source as seen
in \ds9:
\p
\begin{center}
\img{saotrace/static/obs1068_chandra.png}{ds9 image of the PSF}.
\end{center}
\p
The crosshairs mark the position where the support strut shadows meet
as determined by eye: ra=84.91093 degrees, dec=-69.74348 degrees,
(x,y)=(5256,6890).   This coordinate will be used as the position of the
source.  For this observation, this coordinate falls on ACIS-4 (S0).
\p
\sect{Creating the source spectral file}
\p
For an accurate simulation of an observed source, it is important to
make the detector conguration match that of the observation as closely
as possible.  And since the the PSF is energy dependent, an rough idea
of the energy dependence of incident source flux must be obtained.
Here, the latter task will be accomplished by simply extracting the
counts in a region containing the observed PSF and dividing it by the
effective area.  This is known as ``flux-correction'', and involves no
spectral fitting.  Strictly speaking, the validity of this technique
assumes that spectrum does not vary much over the scale of the RMF.
\p
The first step is to create the ARF to be used for the flux-correction.
The creation of the ARF is straightforward via the Bourne shell script:
\p
#v+
#i saotrace/runmarf.sh
#v-
\p
(The above script may be downloaded from
\href{saotrace/runmarf.sh}{here}).
\p
The next step is to extract the counts in the PSF and divide by the
ARF to get the flux corrected spectrum.  One way to do this is via the
standard CIAO tools: \dmellipse to
create a region file containing the source events, and \dmextract to
create the PHA histogram.  Here an \isis script is used to fit an
ellipse to the PSF, extract the counts, and perform the flux
correction.  The details may be found in \href{the
script}{saotrace/fluxcorrellipse.sl}.  The \href{resulting ascii
table}{saotrace/psfflux.txt} containing the spectrum will be input
into both \marx and \saotrace.

\sect{Running marx}

#v+
#i powerlaw/inc/runmarxasp.inc
#v-

#i jdweb_end.tm

