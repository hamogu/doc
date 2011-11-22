#i jdweb.tm
#i local.tm
#d pagename Simulating a Chandra Observation with Marx

#d file#1 \href{powerlaw/$1}{$1}

The example presented here was originally designed to see how well the
\marx PSF compares to that of an actual Chandra observation of a far
off-axis source.  For this purpose, we will use the 1999 Chandra
calibration observation of LMC X-1 observed about 25 arc-minutes
off-axis with the ACIS detector (ObsID 1068).

It is assumed that the user has downloaded the data for obsid 1068
from the archive and reprocessed it with the latest version of \ciao
to produce a level-2 file.  Here is the image of

The source position of LMC X-1 as determined by ... is
ra=84.911875, dec=-69.743253 degrees.

\sect{Running marx}

#v+
#i powerlaw/inc/runmarxasp.inc
#v-

#i jdweb_end.tm

