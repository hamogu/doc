#i jdweb.tm
#i local.tm
#d pagename Simulating a user-defined spectrum with Marx
#d xspec \href{http://heasarc.nasa.gov/xanadu/xspec/}{xspec}
#d sherpa \href{http://cxc.harvard.edu/sherpa/}{sherpa}

#d file#1 \href{powerlaw/$1}{$1}

The purpose of this example is to show how to use \marx to simulate an ACIS
observation of a point source with a user-specified spectrum.  For
simplicity, suppose that we wish to simulate a 3000 ksec observation of
a point source whose spectrum is represented by an absorbed powerlaw,
with a spectral index of 1.8, and a column density of 10^22
atoms/cm^2.  The normalization of the powerlaw will be set to 0.001
photons/keV/cm^2/s at 1 keV.  The large exposure time was chosen to
illustrate the consistency of the \marx ray trace with that of the
underlying calibration data.  

\sect{Creating the spectral file}

\p
The first step is to create a 2-column text file that tabulates
the flux [photons/sec/keV/cm^2] (second column) as a
function of energy [keV] (first column).  The easiest way to create
such a file is to make use of a spectral modeling program such as \isis,
\sherpa or \xspec.   The rest of this tutorial is given in the context of
\isis.

\p
In \isis the absorbed powerlaw model is specified using:
#v+
isis> fit_fun("phabs(1)*powerlaw(1)");
isis> set_par(1, 1);
isis> set_par(2, 0.001);
isis> set_par(3, 1.8);
isis> list_par;
phabs(1)*powerlaw (1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     0                1           0      100000  10^22
  2  powerlaw(1).norm       0     0            0.001           0        0.01  
  3  powerlaw(1).PhoIndex   0     0              1.8           1           3  
isis> save_par ("plaw.p");
#v-
\p
The next step is to convert the parameter file \file{plaw.p} to the
spectrum file that \marx expects.  The \marxflux script may be used to
create a file called \file{plawflux.tbl} in the appropriate format via
#v+
 unix% ./marxflux -e '[0.3:14.0:0.003]' plaw.p plawflux.tbl
#v-
This script requires \isis to be installed and linked to at least
version 2.1 of the \slang library.  (\Marx is distributed with a
script called \tt{xspec2marx} that may be used to create such a file
for \xspec.  More information about using this script in conjunction
with \xspec may be found in the \href{../docs.html}{marx
documentation}).

\p
The \file{plawflux.tbl} file is input to \marx using the following
\file{marx.par} parameters:
#v+
   SpectrumType=FILE
   SpectrumFile=plawflux.tbl
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
prefer to use tools such as \bf{pset} to update the \file{marx.par}
file and then run \marx.  Here, the parameters will be explicitly
passed to \marx via the command line:
#v+
#i powerlaw/inc/runmarx.inc
#v-
This will run the simulation and place the results in a subdirectory
called \tt{plaw}.  The results may be converted to a standard Chandra
level-2 fits file by the \marx2fits program:
#v+
#i powerlaw/inc/runmarx2fits.inc
#v-
The resulting fits file (\tt{plaw_evt2.fits}) may be further processed
with standard \ciao tools.  As some of these tools require the aspect
history, the \marxasp program will be used to create an aspect
solution file that matches the simulation:
#v+
#i powerlaw/inc/runmarxasp.inc
#v-

\sect{Analyzing the simulated data}

Armed with the simulated event file \tt{plaw_evt2.fits} and the aspect
solution file \tt{plaw_asol1.fits}, a PHA file, ARF and RMF may be
made using the standard \ciao tools.  A Bourne shell script that does
this may be found \href{powerlaw/plaw_ciao.sh}{here}.  These files may
be used in a spectral modelling program such as \isis to see whether or
not one can reach the desired science goal from the simulated
observation.  For this example, the goal is to verify that the marx
simulation is consistent with the input spectrum.  To this end, \isis
will be used to fit an absorbed powerlaw to the pha spectrum.  The
figure below showing the resulting fit was created via the following
isis script:
#v+
#i powerlaw/isisfit.sl
#v-
This script produced the following parameter values with a reduced
chi-square of 1.10:
#v+
 Parameters[Variable] = 3[2]
            Data bins = 615
           Chi-square = 673.9226
   Reduced chi-square = 1.099384
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0      0.001008843           0       1e+10  
  3  powerlaw(1).PhoIndex   0     0         1.824765          -2           9  
#v-
\begin{center}
\img{powerlaw/plawfit.png}{Plot of the spectrum}
\end{center}

\p
This example shows that the \marx simulation is consistent with the
underlying calibration products.

#i jdweb_end.tm

