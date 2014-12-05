Simulating a user-defined CCD spectrum with ACIS
=================================================
The purpose of this example is to show how to use |marx| to simulate an ACIS
observation of a point source with a user-specified spectrum.  For
simplicity, suppose that we wish to simulate a 3000 ksec observation of
an on-axis point source whose spectrum is represented by an absorbed powerlaw,
with a spectral index of 1.8, and a column density of 10^22 atoms/cm^2. 
The normalization of the powerlaw will be set to 0.001
photons/keV/cm^2/s at 1 keV.  The large exposure time was chosen to
illustrate the consistency of the |marx| ray trace with that of the
underlying calibration data.  

Creating the spectral file
--------------------------

The first step is to create a 2-column text file that tabulates
the flux [photons/sec/keV/cm^2] (second column) as a
function of energy [keV] (first column).  The easiest way to create
such a file is to make use of a spectral modeling program such as `ISIS`_,
`Sherpa`_ or `XSpec`_.   The rest of this tutorial is given in the context of
`ISIS`_.

In `ISIS`_ the absorbed powerlaw model is specified using::

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

The next step is to convert the parameter file ``plaw.p`` to the
spectrum file that |marx| expects.  The :marxtool:`marxflux` script may be used to
create a file called :download:`plawflux.tbl` in the appropriate format via::

     unix% ./marxflux -e '[0.3:14.0:0.003]' plaw.p plawflux.tbl

This script requires `ISIS`_ to be installed and linked to at least
version 2.1 of the `S-Lang`_ library.  (|marx| is distributed with a
script called :marxtool:`xspec2marx` that may be used to create such a file
for `XSpec`_). 

The ``plawflux.tbl`` file is input to |marx| using the following
``marx.par`` parameters::

   SpectrumType=FILE
   SpectrumFile=plawflux.tbl
   SourceFlux=-1

The :par:`SpectrumType` parameter is set to ``FILE`` to indicate that
|marx| is to read the spectrum from the file specified by the
:par:`SpectrumFile` parameter.  The :par:`SourceFlux` parameter may be
used to indicate the integrated flux of the spectrum.  The value of ``-1``
as given above means that the integrated flux is to be taken from the
file.

Running marx
------------

The next step is to run |marx| in the desired configuration.  Some
prefer to use tools such as :marxtool:`pset` to update the ``marx.par``
file and then run |marx|.  Here, the parameters will be explicitly
passed to |marx| via the command line:

.. include:: runmarx.inc
   :code:

This will run the simulation and place the results in a subdirectory
called ``plaw``.  The results may be converted to a standard Chandra
level-2 fits file by the :marxtool:`marx2fits` program:

.. include:: runmarx2fits.inc
   :code:

The resulting fits file ``plaw_evt2.fits`` may be further processed
with standard `CIAO`_ tools.  As some of these tools require the aspect
history, the :marxtool:`marxasp` program will be used to create an aspect
solution file that matches the simulation:

.. include:: runmarxasp.inc
   :code:

Analyzing the simulated data
-----------------------------

Armed with the simulated event file ``plaw_evt2.fits`` and the aspect
solution file ``plaw_asol1.fits``, a PHA file, ARF and RMF may be
made using the standard `CIAO`_ tools.  A Bourne shell script that does
this may be found in :download:`plaw_ciao.sh`.  These files may
be used in a spectral modelling program such as `ISIS`_ to see whether or
not one can reach the desired science goal from the simulated
observation.  For this example, the goal is to verify that the marx
simulation is consistent with the input spectrum.  To this end, `ISIS`_
will be used to fit an absorbed powerlaw to the pha spectrum.  The
figure below showing the resulting fit was created via the following
ISIS script:

.. include:: isisfit.sl
   :code:

This script produced the following parameter values with a reduced
chi-square of 1.2::

     Parameters[Variable] = 3[2]
                Data bins = 600
               Chi-square = 722.847
       Reduced chi-square = 1.208774
    phabs(1)*powerlaw(1)
     idx  param             tie-to  freeze         value         min         max
      1  phabs(1).nH            0     1                1           0      100000  10^22
      2  powerlaw(1).norm       0     0      0.001003397           0       1e+10  
      3  powerlaw(1).PhoIndex   0     0         1.826904          -2           9  

The ``rplot_counts`` may be used to produce a plot of the resulting
fit.

.. image:: plawfit.*
   :alt: Plot of the spectrum

The residuals show that the model is systematically high for some
energies.  The reason for this can be traced back to energy-dependent
scattering where photons are scattered outside the extraction region.
The CIAO effective area does not include this loss factor, and as a
result, this omission appears in the residuals.  This effect is
apparant because of the enormous number of counts in this simulation.


Simulating pile-up in an ACIS CCD spectrum
==========================================

The purpose of this example is to show how to to use the :marxtool:`marxpileup`
program to simulate the effects of pileup. It is a post-processor that
performs a frame-by-frame analysis of an existing |marx| simulation.
We continue the example from above, where the spectrum had a
somewhat large normalization to ensure that pileup would occur. 

Creating an event file with pile-up
-----------------------------------

:marxtool:`marxpileup` can be run on the eventfile generated by |marx| using:

.. include:: runmarxpileup.inc
   :code:

This will create a directory called ``plaw/pileup/`` and place the
pileup results there.  It also writes a brief summary to the display
resembling::

  Total Number Input: 770961
  Total Number Detected: 482771
  Efficiency: 6.261938e-01

This shows that because of pileup, nearly 40 percent of the events
were lost.

The next step is to run :marxtool:`marx2fits` to create a
corresponding level-2 file called ``plaw_pileup_evt2.fits``.

.. include:: runmarx2fitspileup.inc
   :code:

Since this is a pileup simulation, the ``--pileup`` flag was passed
to :marxtool:`marx2fits`.

In this case we can use the same ARF and RMF as above. However,
it is necessary to create a new PHA file from the
``plaw_pileup_evt2.fits`` event file.  For analyzing a piled
observation of a near on-axis point source, it is recommended that the
extraction region have a radius of 4 ACIS tangent plane pixels.  A
Bourne shell script that runs :ciao:`dmextract` to produce the PHA file
``plaw_pileup_pha.fits`` is :download:`pileup_ciao.sh`.

Analyzing the simulated data
----------------------------

As before, `ISIS`_ will be used to analyze the piled spectrum.

.. include:: isispileup1.inc
   :code:

The fit produces a rather large chi-square per dof of more than 7.5::

   Parameters[Variable] = 3[2]
              Data bins = 659
             Chi-square = 4946.838
     Reduced chi-square = 7.529434
  phabs(1)*powerlaw(1)
   idx  param             tie-to  freeze         value         min         max
    1  phabs(1).nH            0     1                1           0      100000  10^22
    2  powerlaw(1).norm       0     0     0.0004742587           0       1e+10  
    3  powerlaw(1).PhoIndex   0     0         1.593586          -2           9  

Note also that the parameters are different
from the power-law parameters that went into the simulation.  For
example, the normalization is less than half of what was expected, and the
powerlaw index is somewhat low compared to the expected value of 1.8.
In fact, the ``conf`` function shows that the 99 percent confidence
interval on the powerlaw index is from 1.59 to 1.62.

Suspecting that this observation suffers from pileup, we enable the
`ISIS`_ pileup kernel, which introduces a few additional parameters:

.. include:isispileup2.inc
   :code:

which gives::

  phabs(1)*powerlaw(1)
   idx  param             tie-to  freeze         value         min         max
    1  phabs(1).nH            0     1                1           0      100000  10^22
    2  powerlaw(1).norm       0     0     0.0004742587           0       1e+10  
    3  powerlaw(1).PhoIndex   0     0         1.593586          -2           9  
    4  pileup(1).nregions     0     1                1           1          10  
    5  pileup(1).g0           0     1                1           0           1  
    6  pileup(1).alpha        0     0              0.5           0           1  
    7  pileup(1).psffrac      0     1             0.95           0           1  

Given the fact that the PSF fraction varies with
off-axis angle and spectral shape, we will allow it to vary during the
fit:

.. include:: isispileup2b.inc

As before, the ``fit_counts`` command may be used to compute the best
fit parameters.  However, the parameter space in the context of the
pileup kernel is very complex with many local minima, even for a
function as simple as an absorbed powerlaw.  For this reason it is
strongly recommended that pileup fits be performed many times with
different initial values for the parameters to better explore the
parameter space.  The easiest way to do this in `ISIS`_ is to use the
``fit_search`` function, which randomly samples the parameter space
by choosing parameter values uniformly distributed between their
minimum and maximum parameter values.  Before starting, let's set
the powerlaw normalization's maximum value to something reasonable:

.. include:: isispileup3.inc

The above produces::

  phabs(1)*powerlaw(1)
   idx  param             tie-to  freeze         value         min         max
    1  phabs(1).nH            0     1                1           0      100000  10^22
    2  powerlaw(1).norm       0     0     0.0004742587           0        0.01  
    3  powerlaw(1).PhoIndex   0     0         1.593586          -2           9  
    4  pileup(1).nregions     0     1                1           1          10  
    5  pileup(1).g0           0     1                1           0           1  
    6  pileup(1).alpha        0     0              0.5           0           1  
    7  pileup(1).psffrac      0     0             0.95           0           1  

The next step is to use ``fit_search`` to perform the
minimization.  Here we will explore the parameter space by having
``fit_search`` run the ``fit_counts`` function at 100 randomly
sampled locations.  It should be noted that `ISIS`_ will run a number of
the fits in parallel by distributing the computations across the
available CPU cores.

.. include:: isispileup3b.inc

This gives::

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

We see that the reduced chi-square is near what one would expect for a
good fit and that the powerlaw index is very close to the expected
value.  We can use the ``conf`` function to obtain its confidence
interval:

.. include:: isispileup4.inc
   :code:

This indicates that the 90 percent confidence interval on the powerlaw
index to be between 1.78 and 1.80.

The powerlaw normalization may appears to be a bit lower than
expected.  For a near on-axis point source, the 2 arc-second radius
extraction region used contains roughly 90 percent of the flux. Hence
the expected powerlaw normalization should be somewhere in the
neighborhood of 0.0009.  However, it is much less constrained, as can
be seen by computing its 90 percent confidence interval, which runs
from from 0.006 to 0.003.

Here is a plot of the resulting fit, as produced by the
``rplot_counts`` function:

.. figure:: plawpileupfit.*
   :align: center
   :alt: Plot of the pile-up spectrum. Model and data fit well now.

   Plot of the pileup spectrum

