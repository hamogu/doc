Simulating a user-defined spectrum with Marx
=============================================
The purpose of this example is to show how to use |marx| to simulate an ACIS
observation of a point source with a user-specified spectrum.  For
simplicity, suppose that we wish to simulate a 3000 ksec observation of
an on-axis point source whose spectrum is represented by an absorbed powerlaw,
with a spectral index of 1.8, and a column density of 10^22 atoms/cm^2.  The normalization of the powerlaw will be set to 0.001
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
script called \tt{xspec2marx} that may be used to create such a file
for `XSpec`_.  More information about using this script in conjunction
with `XSpec`_ may be found in :ref:`docs`.

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
prefer to use tools such as \bf{pset} to update the \file{marx.par}
file and then run \marx.  Here, the parameters will be explicitly
passed to |marx| via the command line:

.. include:: runmarx.inc
   :code:

This will run the simulation and place the results in a subdirectory
called \tt{plaw}.  The results may be converted to a standard Chandra
level-2 fits file by the \marx2fits program:

.. include:: runmarx2fits.inc
   :code:

The resulting fits file ``plaw_evt2.fits`` may be further processed
with standard `CIAO`_ tools.  As some of these tools require the aspect
history, the \marxasp program will be used to create an aspect
solution file that matches the simulation:

.. include:: runmarxasp.inc
   :code:

Analyzing the simulated data
-----------------------------

Armed with the simulated event file ``plaw_evt2.fits`` and the aspect
solution file ``plaw_asol1.fits``, a PHA file, ARF and RMF may be
made using the standard `CIAO`_ tools.  A Bourne shell script that does
this may be found \href{powerlaw/plaw_ciao.sh}{here}.  These files may
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

