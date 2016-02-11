Contributing code or documentation
==================================

|marx| is developed by the MIT/CXC group and made available under the GPL v2 license
in source code form. The latest release can be found at `distribution`_.

The developers use the `git version control system <https://git-scm.com/>`_
and host the code on github.
We welcome pull requests through github for all apects of the |marx| software, which
includes the following repositories:

- https://github.com/Chandra-MARX/marx : |marx| source code.
  Building the source code has only minimal requirements (a C compiler and GNU autotools).
- https://github.com/Chandra-MARX/doc : This keeps the source code for the documentation.
  The documentation is written using `Sphinx <http://www.sphinx-doc.org/>`_ and requires
  a number of packages to be build:

  - python, sphinx, matplotlib, pygments: for text and figures
  - |marx|, `CIAO`_, `ISIS`_, `Sherpa`_, and `SAOTrace`_ to run the examples and
    generate the associated figures. (The documentation can be build without this, but it
    will be missing all figures in the examples.)
    
- https://github.com/Chandra-MARX/marx-test : Tests that either run a long time or have
  extra dependencies beyond |marx| itself (e.g. `CIAO`_) are collected in this repository.
  
