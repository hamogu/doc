Welcome to MARX's documentation!
================================

.. warning::
   We discovered a severe bug in MARX that affects all simulations of 
   off-axis sources using the MARX mirror module.
   In those simulations a part of the PSF is just cut-off.

   The bug was introduced in 2011 and is present in MARX 5.0, 5.1, and 5.2.
   There is no cut-off distance where
   simulations are "safe", but the area of the PSF that's missing is negligible
   close to the aimpoint and grows with off-axis distance.
   See https://github.com/Chandra-MARX/marx/pull/21 for an example for an affected
   PSF for a 25 arcmin off-axis source.

   For sources that are simulated more than 5 arcmin from the aimpoint and with more than a few
   thousand counts we advice the following work-around:
   Trace the mirror with `SAOTrace`_ or `ChaRT`_ and simulate only the
   detector response with |marx|. Detailed instructions on running `ChaRT`_ and |marx|
   in this way can be found at
   http://cxc.harvard.edu/ciao/threads/psf.html .
   
   We will release a new |marx| version that fixes this bug after the Chandra
   proposal deadline.


.. note:: 
   MARX 5.2 was released in December 2015. This release includes significant
   updates to the Chandra calibration files. See :ref:`installing` for
   installation instructions.

|marx| is a suite of programs created and maintained by the
`MIT/CXC/HETG group <http://space.mit.edu/cxc/>`_ group and is designed
to enable the user to simulate the on-orbit performance of the Chandra
X-ray Observatory. |marx| provides a detailed ray-trace
simulation of how Chandra responds to a variety of astrophysical
sources and can generate standard FITS event files and images as
output. It contains detailed models for Chandra's High Resolution
Mirror Assembly (HRMA), the HETG and LETG gratings, and all the focal
plane detectors.

If you publish any work that made use of |marx|, please cite the
paper `Raytracing
with MARX: x-ray observatory design, calibration, and support (Davis et al. 2012, SPIE 8443, 84431A) <http://adsabs.harvard.edu/abs/2012SPIE.8443E..1AD>`_.


.. toctree::
   :maxdepth: 2

   inbrief/overview
   examples/examples
   indetail/docs

   Reference/reference


Indices and tables
==================

* :ref:`parindex`
* :ref:`genindex`
* :ref:`search`

Developer documentation
=======================

.. toctree::
   :maxdepth: 2

   developer/release
