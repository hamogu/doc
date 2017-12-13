Welcome to MARX's documentation!
================================

.. admonition:: Current version of |marx| is |release|. 

   See :ref:`installing` for installation instructions.


.. warning:: 
   MARX 5.0, 5.1, and 5.2 contain a bug that affects the PSF for 
   simulations of off-axis sources. If you use MARX to simulate any source more
   than 3 arcmin from the aimpoint, **please upgrade to current version 
   |release|** immediately. See :ref:`installing` for installation instructions.
   (On-axis sources and simulations that trace the mirror with `SAOTrace`_ are
   unaffected.)
   See https://github.com/Chandra-MARX/marx/issues/21 for a detailed
   description of the issue.

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
   tests/index

   Reference/reference


Indices and tables
==================

* :ref:`parindex`
* :ref:`genindex`
* :ref:`search`

Contributing to MARX
====================

.. toctree::
   :maxdepth: 2

   developer/contributing
   developer/release
