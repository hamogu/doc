.. _installing:

*******************************
Downloading and Installing Marx
*******************************

|marx| is distributed in the form of a compressed tar file and must be
compiled before it can be used.  This process is fairly painless and
is something that even those who have never compiled a C program
before can do.  It is written in ANSI-C (with a few POSIX extensions)
and is intended to be portable across most 32 and 64 bit Unix
operating systems, as well as MacOSX and CYGWIN.

First download the |marx| `distribution`_ and copy it to a directory that has at least a
couple of hundred megabytes of free disk space.  Note that this
directory and its contents will no longer be needed after |marx| has
been installed.

Next uncompress and untar the file::

    gzip -d marx-dist-5.0.0.tar.gz
    tar xf marx-dist-5.0.0.tar

(Some versions of tar can also uncompress the file, permitting the
above to be accomplished in one step).  At this point the tar file is
no longer needed so it may be removed::

    rm marx-dist-5.0.0.tar

Now change to the newly created directory to start the build process::

    cd marx-dist-5.0.0

The next step is to run the ``configure`` script, which will probe your
system to see what tools are available for compiling |marx|.  Before
doing so, it is recommended that you read the INSTALL file before
proceeding.

At this point you need to think about where you want |marx| to be
installed, and if you want the optional |marxrsp| program to also be
created (* |marxrsp| was written for calibration purposes - it is
not needed by most users*).  If you want |marxrsp| to be installed, then
you will also need to have `cfitsio`_ compiled and installed as detailed
in the ``INSTALL`` file.  For simplicity, here it is assumed that |marxrsp|
will not be installed.

Assume that you want \marx installed in its own tree under
``/opt/marx/\marx-fullversion/``.  This value is known as the
*installation-prefix*.  It is important to understand that with
this choice the resulting \marx executable will be placed in
``/opt/marx/\marx-fullversion/bin/``.

Now run the ``configure`` script
specifying this value as the ``--prefix`` argument::

    ./configure --prefix=/opt/marx/5.0.0

If all has gone well, the last bit of output from the above command
should resemble::

    You are compiling MARX with the following compiler configuration:
       CC = gcc
          .
          .
       MARX parameter files will be installed in /opt/marx/5.0.0/share/marx/pfiles/.
            
       To continue the build process, run 'make'.

If not, then you may not have the necessary tools installed to compile
\marx, or you have an unsupported system.  If you are unable to
resolve the problem on your own, the contact \marx-email-address.

Assuming all has gone well, execute the ``make`` command::

    make

(If this step fails and you are unable to resolve the problem, then
 contact \marx-email-address.)

The final step in the installation process is to actually install the
compiled executables.  If you do not have write permission to the
installation-prefix directory (``/opt/marx/\marx-fullversion`` in this case),
then you will need to obtain the appropriate privileges to complete
the next step.  For example, this may require temporarily becoming the
``root`` user.  Now run::

    make install

to complete the installation.  As indicated above, the \marx
executable will be copied to ``/opt/marx/\marx-fullversion/bin/``.  As
such, it is recommended this directory be added to the user's
``PATH`` environment variable.  The install step will create the
following directories:

``/opt/marx/\marx-fullversion/bin/``
    Directory where |marx|, |marx2fits|, and other |marx| -related executables are placed.

``/opt/marx/\marx-fullversion/share/marx/data/``
    Directory under which the |marx| calibration data files are located.

``/opt/marx/\marx-fullversion/share/marx/pfiles/``
    The parameter files used by |marx| are located here.

``/opt/marx/\marx-fullversion/share/doc/marx/``
    Directory containing |marx| -related documentation.

``/opt/marx/\marx-fullversion/lib/``
    Static versions of libraries distributed with and used by |marx| are put here.

``/opt/marx/\marx-fullversion/include/``
    The C header files of the |marx| libraries are put here.

``/opt/marx/\marx-fullversion/lib/marx/``
    Contains miscellaneous |marx| -related tools.

As the above indicates, the |marx| data files will be copied to the
``/opt/marx/\marx-fullversion/share/marx/data/`` directory.  |marx| will
automatically search this directory for calibration files.  Also note
that the parameter files will be placed under
``/opt/marx/\marx-fullversion/share/marx/pfiles/``.  As a helpful reminder, this
location is reported when \marx is invoked as ``marx --help``.

The parameter files are **NOT** automatically loaded by |marx| unless the ``UPARM`` or ``PFILES`` environment variables are set appropriately.  For this
reason, it is recommended that the user copy these files to the
directory where the simulation will be performed.  

Known Bugs and Limitations
--------------------------

The clang compiler
~~~~~~~~~~~~~~~~~~
See Mac OS X below.

Mac OS X
~~~~~~~~
The default C compiler on Mac OS X is ``clang``. Unfortunately, Apple decided to alias ``gcc`` to point to ``clang``, 
so that is looks as if ``gcc`` was available. ``clang`` is a relatively new compiler and under rapid development.
We found that |marx| compiles successfully with ``clang``, but before ``clang 3.5`` there is a bug in the optimization
that leads to wrong numerical results. Until ``clang`` is a bit more mature, we recommend to compile |marx| without
optimizations (``CFLAGS=-g``) and **not** with the default ``CFLAGS=-g -O``.



Ultrix
~~~~~~

There appears to be a bug in the Ultrix cc optimizer which can lead to
problems building the **MARX **suite. The bug seems to be caused by the
creation of bad assembly code which can lead to core dumps during the
assembly process. Typically, when this bug occurs, the marx executable
itself compiles fine, but the full build of the other tools in the suite
will produce a fatal error during compilation. On this system, it is
recommended that, before configuring, you set the CFLAGS environment
variable to “-g”.

::

    unix% setenv CFLAGS -g
    unix% ./configure

