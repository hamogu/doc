#i jdweb.tm
#i local.tm
#d pagename Simulating Pileup with marx
#d xspec \bf{xspec}
#d sherpa \bf{sherpa}

#d file#1 \href{pileup/$1}{$1}

The purpose of this example is to show how to to use the \marxpileup
program to simulate the effects of pileup. It is a post-processor that
performs a frame-by-frame analysis of an existing \marx simulation.
Here the simulated data from the \href{powerlaw.html}{powerlaw
simulation} will be used.  The spectrum used for that simulation had a
somewhat large normalization to ensure that pileup would occur.  If
you have not already done so, then you should review
\href{powerlaw.html}{that example} first.
\p
Assuming that the simulation to be processed is in the \tt{plaw/}
subdirectory, \marxpileup is run using
#v+
#i powerlaw/inc/runmarxpileup.inc
#v-
This will create a directory called \tt{plaw/pileup/} and place the
pileup results there.  It also writes a brief summary to the display
resembling
#v+
  Total Number Input: 770961
  Total Number Detected: 482771
  Efficiency: 6.261938e-01
#v-
This shows that because of pileup, nearly 40 percent of the events
were lost.
\p
The next step is to run \marx2fits to create a
corresponding level-2 file called \tt{plaw_pileup_evt2.fits}.
#v+
#i powerlaw/inc/runmarx2fitspileup.inc
#v-
Since this is a pileup simulation, the \tt{--pileup} flag was passed
to \marx2fits.

\p
As in the \href{powerlaw.html}{powerlaw example}, \ciao tools may be
used to produce a PHA file, and ARF, and an RMF for subsequent
analysis.  The same ARF and RMF that was used for the
\href{powerlaw.html}{powerlaw simulation} can be used here.  However,
it is necessary to create a new PHA file from the
\tt{plaw_pileup_evt2.fits} event file.  For analyzing a piled
observation of a near on-axis point source, it is recommended that the
extraction region have a radius of 4 ACIS tangent plane pixels.  A
Bourne shell script that runs \dmextract to produce the PHA file
\tt{plaw_pileup_pha.fits} may be found
\href{powerlaw/pileup_ciao.sh}{here}.

\hline
\h2{Analyzing the simulated data}
\hline

As before, \isis will be used to analyze the piled spectrum.
#v+
#i powerlaw/inc/isispileup1.inc
#v-
The fit produces a rather large chi-square per dof of more than 7.5:
#v+
 Parameters[Variable] = 3[2]
            Data bins = 659
           Chi-square = 4946.838
   Reduced chi-square = 7.529434
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0     0.0004742587           0       1e+10  
  3  powerlaw(1).PhoIndex   0     0         1.593586          -2           9  
#v-
Note also that the parameters are different
from the power-law parameters that went into the simulation.  For
example, the normalization is less than half of what was expected, and the
powerlaw index is somewhat low compared to the expected value of 1.8.
In fact, the \tt{conf} function shows that the 99 percent confidence
interval on the powerlaw index is from 1.59 to 1.62.
\p
Suspecting that this observation suffers from pileup, we enable the
\isis pileup kernel, which introduces a few additional parameters:
#v+
#i powerlaw/inc/isispileup2.inc
#v-
#v+
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0     0.0004742587           0       1e+10  
  3  powerlaw(1).PhoIndex   0     0         1.593586          -2           9  
  4  pileup(1).nregions     0     1                1           1          10  
  5  pileup(1).g0           0     1                1           0           1  
  6  pileup(1).alpha        0     0              0.5           0           1  
  7  pileup(1).psffrac      0     1             0.95           0           1  
#v-
Given the fact that the PSF fraction varies with
off-axis angle and spectral shape, we will allow it to vary during the
fit:
#v+
#i powerlaw/inc/isispileup2b.inc
#v-

\p
As before, the \tt{fit_counts} command may be used to compute the best
fit parameters.  However, the parameter space in the context of the
pileup kernel is very complex with many local minima, even for a
function as simple as an absorbed powerlaw.  For this reason it is
strongly recommended that pileup fits be performed many times with
different initial values for the parameters to better explore the
parameter space.  The easiest way to do this in \isis is to use the
\tt{fit_search} function, which randomly samples the parameter space
by choosing parameter values uniformly distributed between their
minimum and maximum parameter values.  Before starting, let's set
the powerlaw normalization's maximum value to something reasonable:
#v+
#i powerlaw/inc/isispileup3.inc
#v-
The above produces:
#v+
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0     0.0004742587           0        0.01  
  3  powerlaw(1).PhoIndex   0     0         1.593586          -2           9  
  4  pileup(1).nregions     0     1                1           1          10  
  5  pileup(1).g0           0     1                1           0           1  
  6  pileup(1).alpha        0     0              0.5           0           1  
  7  pileup(1).psffrac      0     0             0.95           0           1  
#v-

\p
The next step is to use \tt{fit_search} to perform the
minimization.  Here we will explore the parameter space by having
\tt{fit_search} run the \tt{fit_counts} function at 100 randomly
sampled locations.  It should be noted that \isis will run a number of
the fits in parallel by distributing the computations across the
available CPU cores.
#v+
#i powerlaw/inc/isispileup3b.inc
#v-
This gives:
#v+
 Parameters[Variable] = 7[4]
            Data bins = 659
           Chi-square = 751.8835
   Reduced chi-square = 1.147914
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0     0.0007544917           0        0.01  
  3  powerlaw(1).PhoIndex   0     0         1.790701          -2           9  
  4  pileup(1).nregions     0     1                1           1          10  
  5  pileup(1).g0           0     1                1           0           1  
  6  pileup(1).alpha        0     0        0.4686956           0           1  
  7  pileup(1).psffrac      0     0         0.775919           0           1  
#v-
\p
We see that the reduced chi-square is near what one would expect for a
good fit and that the powerlaw index is very close to the expected
value.  We can use the \tt{conf} function to obtain its confidence
interval:
#v+
#i powerlaw/inc/isispileup4.inc
#v-
This indicates that the 90 percent confidence interval on the powerlaw
index to be between 1.78 and 1.80.

\p
The powerlaw normalization may appears to be a bit lower than
expected.  For a near on-axis point source, the 2 arc-second radius
extraction region used contains roughly 90 percent of the flux. Hence
the expected powerlaw normalization should be somewhere in the
neighborhood of 0.0009.  However, it is much less constrained, as can
be seen by computing its 90 percent confidence interval, which runs
from from 0.006 to 0.003.

\p
Here is a plot of the resulting fit, as produced by the
\tt{rplot_counts} function:
\begin{center}
\img{powerlaw/plawpileupfit.png}{Plot of the pileup spectrum}
\end{center}

#i jdweb_end.tm

