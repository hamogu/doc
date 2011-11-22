#i jdweb.tm
#i local.tm
#d pagename Simulating a user-defined spectrum with Marx
#d xspec \bf{xspec}
#d sherpa \bf{sherpa}

#d file#1 \href{aped/$1}{$1}
#d HETG \href{http://space.mit.edu/HETG/}{HETG}
#d aped \href{http://cxc.harvard.edu/atomdb/}{aped}

The purpose of this example is to show how to use \marx to simulate
an \HETG grating spectrum of a star whose spectrum is represented by an
\aped model.

\sect{Creating the spectral file for marx}

The generation of the spectral file for \marx is a bit more involved
than that of the \href{powerlaw.html}{powerlaw} example.  As before,
\marxflux will be used to generate the spectral file from the
parameter file describing the model.  But in this case, the plasma
model must be created before \isis can compute the model flux. So, the
idea is to put the definition of the model into a file
called \file{apedfun.sl}, which not only defines the model but also
creates the parameter file that \marxflux will load.
The contents of \file{apedfun.sl} are:
#v+
#i aped/apedfun.sl
#v-
\p
Then the \marxflux script may be used to create the spectral file via
#v+
  marxflux --script apedfun.sl -l '[1:30:#16384]' aped.p apedflux.tbl
#v-
Here, the \tt{--script apedfun.sl} arguments instruct \marxflux to
execute the \file{apedfun.sl} file.  The \tt{-l '[1:30:#16384]'}
parameters indicate that a 16384 point wavelength grid running from
1 to 30 angstroms is to be used for the spectrum--- \marxflux will
convert this to energy units.  A plot of the spectrum in
\file{apedflux.tbl} is shown below.

\p
\begin{center}
\img{aped/apedflux.png}{Plot of the spectrum}
\end{center}

\sect{Running marx}

The next step is to run \marx in the desired configuration.  For this
example, ACIS-S and the \HETG are used:
#v+
#i aped/runmarx.inc
#v-
\p
This will run the simulation and place the results in a subdirectory
called \tt{aped}.  The results may be converted to a standard Chandra
level-2 fits file by the \marx2fits program:
#v+
#i aped/runmarx2fits.inc
#v-
\p
The resulting fits file (\tt{aped_evt2.fits}) may be further processed
with standard \ciao tools, as described below.  As some of these tools
require the aspect history, the \marxasp program will be used to
create an aspect solution file that matches the simulation:
#v+
#i aped/runmarxasp.inc
#v-

\sect{Creating a type-II PHA file}

For a \chandra grating observation, the \ciao \ciaotool{tgextract} tool
may used to create a type-II PHA file.  Before this can be done, an
extraction region mask file must be created using the \ciao
\ciaotool{tg_create_mask}, followed by order resolution using
\ciaotool{tg_resolve_events}.  The first step is to determine the
source position, which is used by
\ciaotool{tg_create_mask}.  While there are many ways to do this, perhaps the
most flexible way is to use \findzo as described on
\href{\findzourl}{its web page}. For this particular example, the
position of the zeroth order in sky coordinates is (4017.88, 4141.43).

\p
The following Bourne shell script runs the above set of tools to
create a PHA2 file called \tt{aped_pha2.fits}.
#v+
#i aped/aped_ciao.sh
#v-

#%+
An important by-product of this script is the \tt{evt1a} file, which
includes columns for the computed values of the wavelengths and orders
of the diffracted events.  In fact, \ciaotool{tgextract} makes use of
those columns to create the PHA2.  An extremely useful diagnostic
plot, known as an order-sorting plot, is a plot of the diffracted
wavelength vs the CCD energy energy of the events.  Here is such a
plot constructed from \tt{aped_evt1a.fits} for the MEG events:
\begin{center}
\img{aped/apedmeg1.png}{Plot of the MEG+1 counts spectrum}
\end{center}
You can see disperson This 
This plot can be used to look at gain variations across the detector

file, which contains the order sorting 
#%-

The resulting file may be loaded into isis and displayed using
#v+
   isis> load_data ("aped_pha2.fits");
   isis> list_data;
#v-
with the result
#v+
Current Spectrum List:
 id    instrument   m prt src    use/nbins   A   R     totcts   exp(ksec)  target
  1     HETG-ACIS  -3  1   1    8192/ 8192   -   -  3.5100e+02    78.988  POINT
  2     HETG-ACIS  -2  1   1    8192/ 8192   -   -  1.0040e+03    78.988  POINT
  3     HETG-ACIS  -1  1   1    8192/ 8192   -   -  1.4086e+04    78.988  POINT
  4     HETG-ACIS   1  1   1    8192/ 8192   -   -  1.2569e+04    78.988  POINT
  5     HETG-ACIS   2  1   1    8192/ 8192   -   -  6.7800e+02    78.988  POINT
  6     HETG-ACIS   3  1   1    8192/ 8192   -   -  2.2800e+02    78.988  POINT
  7     HETG-ACIS  -3  2   1    8192/ 8192   -   -  2.6500e+03    78.988  POINT
  8     HETG-ACIS  -2  2   1    8192/ 8192   -   -  6.9800e+02    78.988  POINT
  9     HETG-ACIS  -1  2   1    8192/ 8192   -   -  2.9684e+04    78.988  POINT
 10     HETG-ACIS   1  2   1    8192/ 8192   -   -  2.9691e+04    78.988  POINT
 11     HETG-ACIS   2  2   1    8192/ 8192   -   -  5.8600e+02    78.988  POINT
 12     HETG-ACIS   3  2   1    8192/ 8192   -   -  2.0430e+03    78.988  POINT
#v-
A plot of the MEG-1 spectrum, which corresponds to \tt{id=9} in the
above list may be created using
#v+
   isis> xrange (1, 25);
   isis> group_data (9, 2);
   isis> plot_data (9);
#v-
\begin{center}
\img{aped/apedmeg1.png}{Plot of the MEG+1 counts spectrum}
\end{center}

In making the above plot, the \tt{group_data} function was used to
rebin the data by combining adjacent wavelength channels.

#i jdweb_end.tm

