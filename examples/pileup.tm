#i jdweb.tm
#i local.tm
#d pagename Simulating Pileup with marx
#d xspec \bf{xspec}
#d sherpa \bf{sherpa}

#d file#1 \href{pileup/$1}{$1}

The purpose of this example is to show how to to use the \marxpileup
program to simulate the effects of pileup.  
\marxpileup program is a post-processor that performs a
frame-by-frame analysis of an existing \marx simulation.  Here the
simulated data from the \href{powerlaw.html}{powerlaw simulation} will
be used.  The spectrum used for that simulation had a somewhat large
normalization to ensure that pileup would occur.  If you have not
already done so, then you should review \href{powerlaw.html}{that
example} first.
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
The fit produces a rather large chi-square per dof of about 7.6:
#v+
 Parameters[Variable] = 3[2]
            Data bins = 670
           Chi-square = 5071.014
   Reduced chi-square = 7.591339
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0     0.0004696829           0       1e+10  
  3  powerlaw(1).PhoIndex   0     0         1.583247          -2           9  
#v-
Note also that the parameters are different
from the power-law parameters that went into the simulation.  For
example, the normalization is less than half of what was expected, and the
powerlaw index is somewhat low compared to the expected value of 1.8.
In fact, the \tt{conf} function shows that the upper 90 percent
confidence limit on the index is less than 1.6.
\p
Suspecting that this observation suffers from pileup, we enable the
\isis pileup kernel.  Given the fact that the PSF fraction varies with off-axis angle, we
allow if to vary from 0.8 to 1.0:
#v+
#i powerlaw/inc/isispileup2.inc
#v-
The above produces:
#v+
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0     0.0004696829           0       1e+10  
  3  powerlaw(1).PhoIndex   0     0         1.583247          -2           9  
  4  pileup(1).nregions     0     1                1           1          10  
  5  pileup(1).g0           0     1                1           0           1  
  6  pileup(1).alpha        0     0              0.5           0           1  
  7  pileup(1).psffrac      0     0             0.95         0.8           1  
#v-
\p
Now the \tt{fit_counts} command may be used to compute the fit using
the pileup kernel.  Keep in mind that the parameter space in the
context of the pileup kernel is very complex with many local minima.
For this reason it is strongly recommended that pileup fits be
performed many times with different initial values for the parameters.
For the example here, using the \tt{subplex} fitting method a couple
of times is sufficient:
#v+
#i powerlaw/inc/isispileup3.inc
#v-
This generates the output:
#v+
 Parameters[Variable] = 7[4]
            Data bins = 670
           Chi-square = 703.912
   Reduced chi-square = 1.056925
phabs(1)*powerlaw(1)
 idx  param             tie-to  freeze         value         min         max
  1  phabs(1).nH            0     1                1           0      100000  10^22
  2  powerlaw(1).norm       0     0     0.0008413186           0       1e+10  
  3  powerlaw(1).PhoIndex   0     0         1.772188          -2           9  
  4  pileup(1).nregions     0     1                1           1          10  
  5  pileup(1).g0           0     1                1           0           1  
  6  pileup(1).alpha        0     0        0.3384504           0           1  
  7  pileup(1).psffrac      0     0        0.8464363         0.8           1  
#v-
Under the pileup kernel the powerlaw normalization is close to
what was expected.  In fact, for a near on-axis point source, the
extraction region used contains about 0.9 percent of the flux; hence
the expected powerlaw normalization should be somewhere in the
neighborhood of 0.9*0.001.  The powerlaw index is about what was
expected and much closer than that predicted by the standard linear
kernel.
\p
Here is a plot of the resulting fit:
\begin{center}
\img{powerlaw/plawpileupfit.png}{Plot of the pileup spectrum}
\end{center}

#i jdweb_end.tm

