.. _sect-ex-aped:

Simulating a thermal plasma with the HETGS grating
==================================================

The purpose of this example is to show how to use |marx| to simulate
an HETG grating spectrum of a star whose spectrum is represented by an
`APEC <http://www.atomdb.org>`_  model.

Creating the spectral file for |marx|
-------------------------------------
As in :ref:`sect-ex-ACISCCD`, we will use
:marxtool:`marxflux` again to generate the spectral file from the
parameter file describing the model.  But in this case, the plasma
model must be created before `ISIS`_ can compute the model flux. So, the
idea is to put the definition of the model into a file, which not only defines the model but also
creates the parameter file that :marxtool:`marxflux` will load.
The contents of file :download:`apedfun.sl` that defines the model is:

.. sourceinclude:: apedfun.sl
   :prepend: # ISIS file defining spetral model

Then the :marxtool:`marxflux` script may be used to create the spectral file via::

  marxflux --script apedfun.sl -l '[1:30:#16384]' aped.p apedflux.tbl

Here, the ``--script apedfun.sl`` arguments instruct :marxtool:`marxflux` to
execute the ``apedfun.sl`` file.  The ``-l '[1:30:#16384]'``
parameters indicate that a 16384 point wavelength grid running from
1 to 30 angstroms is to be used for the spectrum - :marxtool:`marxflux` will
convert this to energy units.  A plot of the spectrum in
:download:`apedflux.tbl` is shown below.

.. figure:: apedflux.*
   :align: center

   Plot of the spectrum


Running marx
------------

The next step is to run |marx| in the desired configuration.  For this
example, ACIS-S and the HETG are used:

.. literalinclude:: runmarx.inc
   :language: bash

This will run the simulation and place the results in a subdirectory
called ``aped``.  The results may be converted to a standard Chandra
level-2 fits file by the :marxtool:`marx2fits` program:

.. literalinclude:: runmarx2fits.inc
   :language: bash

The resulting fits file ``aped_evt2.fits`` may be further processed
with standard `CIAO`_ tools, as described below.  As some of these tools
require the aspect history, the :marxtool:`marxasp` program will be used to
create an aspect solution file that matches the simulation:

.. literalinclude:: runmarxasp.inc
   :language: bash

Creating a type-II PHA file
----------------------------
For a Chandra grating observation, the `CIAO`_ :ciao:`tgextract` tool
may used to create a type-II PHA file.  Before this can be done, an
extraction region mask file must be created using 
:ciao:`tg_create_mask`, followed by order resolution using
:ciao:`tg_resolve_events`.  The first step is to determine the
source position, which is used by
:ciao:`tg_create_mask`.  There are many ways to do this; the easiest might be
to open the event file in `ds9`_, put a circles on the source
position and use the ds9 functions to center it. Another way would be to use
the *find zero-order* algorithm of
`findzo <http://space.mit.edu/cxc/analysis/findzo/>`_ , 
which is robust enough to work on heavily piled-up sources with read-out
streaks. For this particular example, the
position of the zeroth order in sky coordinates is (4017.88, 4141.43).

The following Bourne shell script runs the above set of tools to
create a PHA2 file called ``aped_pha2.fits``:

.. literalinclude:: aped_ciao.sh
   :language: bash

An important by-product of this script is the ``evt1a`` file, which
includes columns for the computed values of the wavelengths and orders
of the diffracted events.  In fact, :ciao:`tgextract` makes use of
those columns to create the PHA2.

The resulting event file may be loaded into `ISIS`_ and displayed using
::

   isis> load_data ("aped_pha2.fits");
   isis> list_data;

with the result::

    Current Spectrum List:
     id    instrument part/m  src    use/nbins   A   R     totcts   exp(ksec)  target
      1     HETG-ACIS  heg-1   1    8192/ 8192   -   -  1.3249e+04    78.988  POINT
    file:  aped_pha2.fits
      2     HETG-ACIS  heg+1   1    8192/ 8192   -   -  1.1891e+04    78.988  POINT
    file:  aped_pha2.fits
      3     HETG-ACIS  meg-1   1    8192/ 8192   -   -  2.6507e+04    78.988  POINT
    file:  aped_pha2.fits
      4     HETG-ACIS  meg+1   1    8192/ 8192   -   -  2.6388e+04    78.988  POINT
    file:  aped_pha2.fits


A plot of the MEG-1 spectrum, which corresponds to ``id=3`` in the
above list may be created using:

.. sourceinclude:: isismeg1.sl
   :indent: "isis> "


.. figure:: apedmeg1.*
   :align: center

   Plot of the MEG-1 counts spectrum

In making the above plot, the ``group_data`` function was used to
rebin the data by combining adjacent wavelength channels.


