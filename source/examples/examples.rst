.. _examples:

***********************
Examples of MARX in use
***********************

This section contains examples of |marx| in use from rather trivial use cases to complex and demanding analysis scripts. Going through these examples is the best way to discover the power of |marx|. They also provide a great starting point for developing your own analysis.

All of the examples assume
that you are working in a directory where you have write permission
and enough disk space for the simulation.  It is also assumed that the
|marx| executables are on the search path and that the |marx| parameter
files ``marx.par``, ``marxasp.par``, and 
``marxpileup.par``) are located in the current directory.  Assuming you installed |marx| as described in :ref:`installing`, the
latter requirement may be accomplished by running::

  unix% marx --help
    .
    .
  marx parameter files may be found in:
   /opt/marx5.0/share/marx/pfiles/

Simply copy the files from the indicated directory to the current one::

  unix% cp /opt/marx5.0/share/marx/pfiles/*.par .

.. toctree::
   :maxdepth: 1
 
   arfrmf

   ACISpowerpileup/powerlaw
   aped/aped
   hetgplaw/hetgplaw
   LETGpow/letgplaw



