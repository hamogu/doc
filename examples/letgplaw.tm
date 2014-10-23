#i jdweb.tm
#i local.tm
#d pagename Simulating an LETG/ACIS-S observation

#d file#1 \href{letgplaw/$1}{$1}

In this example, we simulate an LETG/ACIS-S observation with \marx.
The primary goal of this exercise is to see how well \marx can
simulate this instrument combination by performing a spectral analysis
of the result.  For simplicity, we assume an on-axis point source and an
absorbed powerlaw spectrum with a column density of 10^19 atoms/cm^2, a
spectral index of 1.8, and a normalization of 0.1
photons/keV/cm^2/sec at 1 keV,   Rather than specifying an
exposure time for the observation as in the other examples, here we
specify the desired number of detected events.  In this case, the
simulation will be run until 10,000,000 (1e7) events have been
detected.

\sect{Creating the spectral file}

\p
The first step is to create a 2-column text file that tabulates
the absorbed powerlaw flux [photons/sec/keV/cm^2] (second column)
as a function of energy [keV] (first column).  The easiest way to create
such a file is to make use of a spectral modeling program.  Here as in
the other examples, we use \isis,

\p
In \isis the absorbed powerlaw model is specified using:
#v+
isis> fit_fun("phabs(1)*powerlaw(1)");
isis> set_par(1, 0.001);
isis> set_par(2, 0.1);
isis> set_par(3, 1.8);
isis> list_par;
phabs(1)*powerlaw (1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     0            0.001           0      100000  10^22
  2  powerlaw(1).norm       0     0              0.1           0        0.01
  3  powerlaw(1).PhoIndex   0     0              1.8           1           3
isis> save_par ("letgplaw.p");
#v-
\p
The next step is to convert the parameter file \file{letgplaw.p} to the
spectrum file that \marx expects.  The \marxflux script may be used to
create a file called \file{letgplawflux.tbl} in the appropriate format via
#v+
 unix% ./marxflux -e '[0.03:12.0:0.001]' letgplaw.p letgplawflux.tbl
#v-
This script requires a recent version of \isis to be installed. (\Marx
is also distributed with a script called \tt{xspec2marx} that may be
used to create such a file for \xspec.  More information about using
this script in conjunction with \xspec may be found in the
\href{../docs.html}{marx documentation}).

\p
The \file{letgplawflux.tbl} file is input to \marx using the following
marx.par parameters:
#v+
   SpectrumType=FILE
   SpectrumFile=letgplawflux.tbl
   SourceFlux=-1
#v-
The \tt{SpectrumType} parameter is set to \tt{FILE} to indicate that
\marx is to read the spectrum from the file specified by the
\tt{SpectrumFile} parameter.  The \tt{SourceFlux} parameter may be
used to indicate the integrated flux of the spectrum.  The value of -1
as given above means that the integrated flux is to be taken from the
file.

\sect{Running marx}

The next step is to run \marx in the desired configuration.  Some
prefer to use tools such as \bf{pset} to update the marx.par
file and then run \marx.  Here, the parameters will be explicitly
passed to \marx via the command line:
#v+
#i letgplaw/inc/runmarx.inc
#v-
Note the use of a \em{negative} value of the \tt{NumRays} parameter.
This tells \marx that the simulation is to continue until the absolute
value of that number of rays have been detected.  The results of the
simulation will be written to a subdirectory called \tt{letgplaw}, as
specified by the \tt{OutputDir} parameter.  After the simulation has
completed, a standard Chandra event file may be created using the \marx2fits
program:
#v+
#i letgplaw/inc/runmarx2fits.inc
#v-
\p
The fits file (\tt{letgplaw_evt1.fits}) can be further processed
with standard \ciao tools.  As some of these tools require the aspect
history, the \marxasp program is used to create an aspect
solution file that matches the simulation:
#v+
#i letgplaw/inc/runmarxasp.inc
#v-

\p
It is interesting to look at the event file with a viewer such as
\ds9.  Here we use \evt2img, which displays an RGB image of the events
projected to the sky plane.
\p
\begin{center}
\img{letgplaw/rgbimage.png}{RGB image of the event file}.
\end{center}
\p
The energy bands were color-coded as follows: red: 0.0 to 0.5 keV,
green: 0.5 to 2.0 keV, blue: 2.0 to 12 keV.
\p
This image shows what the pattern of events looks like near zeroth
order.  There are a number of features in this image that are worth
pointing out.  The thick blue line in the middle of the fan-like
structure that extends from the top left of the figure to the bottom
right corresponds to diffracted photons from the primary grating bars
of the LEG.  The events in this line are the subject of the spatial
extraction step when creating the event histograms for spectral
analysis, as described below.  The other blue lines in the fan-like
structure correspond to photons that have also been diffracted by the
fine support structure of the LEG. This fine support structure forms a
grating that diffracts in a direction orthogonal to the primary
diffraction direction.  The events in the multicolored line that runs
from the bottom left to the upper right consists of two contributions.
The first is from photons that arrived at the detector while the image
was being read out between frames.  The second is from the
undiffracted photons from the primary grating that have been
diffracted from the LEG fine support structure. The red star-like
pattern in the center of the figure was produced by photons that have
diffracted from the LEG's coarse support structure, whose 2 mm period
diffracts only the very lowest energy photons through an appreciable
angle.  Finally, if one looks closely enough, the shadowing of the
mirror support struts may be seen near zeroth order.

\sect{Analyzing the simulated data}

The (type-II) PHA file, grating ARFs and RMFs can be produced using the
standard \ciao tools using the simulated event file
\tt{letgplaw_evt2.fits} and the aspect solution file
\tt{letgplaw_asol1.fits} as inputs. A Bourne shell script that does
this may be found \href{letgplaw/letgplaw_ciao.sh}{here}.  In
particular, this script constructs an order-sorted level 1.5 file from
which plus and minus first order events are extracted, and creates the
corresponding ARFs and RMFs for the extracted spectra.
\p
For this example, we wish to verify that the marx simulation is
consistent with the input spectrum.  To this end, we use \isis to fit
an absorbed powerlaw to the pha spectra.  The spectral fits to the
plus and minus first order histograms can be carried out using the
following \isis commands:
#v+
#i letgplaw/inc/isisfit.inc
#v-
This command sequence produced the following parameter values and a reduced
chi-square less than 1:
#v+
 Parameters[Variable] = 3[2]
            Data bins = 8192
           Chi-square = 6987.855
   Reduced chi-square = 0.8532179
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1            0.001           0      100000  10^22
  2  powerlaw(1).norm       0     0        0.1011472           0       1e+10  
  3  powerlaw(1).PhoIndex   0     0         1.795557          -2           9  
#v-

\p
Plots of the spectral fit to count histograms are constructed using
the \tt{rplot_counts} command applied to the minus first order and plus first
order datasets.
#v+
isis> rplot_counts(m1);
#v-
\begin{center}
\img{letgplaw/letgplaw_fit_m1.png}{Plot of the -1 spectrum}
\end{center}
\p
#v+
isis> rplot_counts(p1);
#v-
\begin{center}
\img{letgplaw/letgplaw_fit_p1.png}{Plot of the +1 spectrum}
\end{center}
\p
(Since we are working with grating data, it is most natural to work
with wavelength units. The corresponding plots in energy units may be found
below.)
\p
The main systematic features in the residuals of the plots are due to
the clipping of events by too narrow of a window in order sorting
space.  This may be seen in the next figure, the so-called
order-sorting plot, which gives the number of events as a function of
dispersion coordinate (abscissa) and effective order (ordinate).
Events with effective orders below 0.7 and above 1.2 were
excluded from the count histograms.  In this simulation, such events
appear mainly at wavelengths less than about 7 angstroms in both
orders, and just above 20 angstroms in the positive first order.
\begin{center}
\img{letgplaw/LEG_ds9sls_osort.png}{Order sorting plot}
\end{center}
\p
For grating data, \isis defaults to using wavelength units.  We use
the \tt{plot_unit} command to tell \isis to use energy units for
plotting:
#v+
#i letgplaw/inc/isisplotkev.inc
#v-
Then the \tt{rplot_counts} command will produce the following plots:
\p
\begin{center}
\img{letgplaw/letgplaw_fit_m1_kev.png}{m1 keV plot}
\end{center}
\begin{center}
\img{letgplaw/letgplaw_fit_p1_kev.png}{p1 keV plot}
\end{center}
#i jdweb_end.tm

