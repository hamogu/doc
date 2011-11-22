#i jdweb.tm
#i local.tm
#d pagename Downloading and Installing Marx

\Marx is distributed in the form of a compressed tar file and must be
compiled before it can be used.  This process is fairly painless and
is something that even those who have never compiled a C program
before can do.  It is written in ANSI-C (with a few POSIX extensions)
and is intended to be portable across most 32 and 64 bit Unix
operating systems, as well as MacOSX and CYGWIN.

\p
First download \href{\marx-tar-file-url}{the marx tar file} from
\url{\marx-download-url/} and copy it to a directory that has at least a
couple of hundred megabytes of free disk space.  Note that this
directory and its contents will no longer be needed after \marx has
been installed.

\p
Next uncompress and untar the file:
#v+
    # gzip -d marx-dist-4.5.0.tar.gz
    # tar xf marx-dist-4.5.0.tar
#v-
(Some versions of tar can also uncompress the file, permitting the
above to be accomplished in one step).  At this point the tar file is
no longer needed so it may be removed:
#v+
    # /bin/rm marx-dist-4.5.0.tar
#v-
Now change to the newly created directory to start the build process:
#v+
    # cd marx-dist-4.5.0
#v-
The next step is to run the \tt{configure} script, which will probe your
system to see what tools are available for compiling \marx.  Before
doing so, it is recommended that you read the INSTALL file before
proceeding.
\p
At this point you need to think about where you want \marx to be
installed, and if you want the optional \marxrsp program to also be
created (\em{\marxrsp was written for calibration purposes--- it is
not needed by most users}).  If you want \marxrsp to be installed, then
you will also need to have \cfitsio compiled and installed as detailed
in the INSTALL file.  For simplicity, here it is assumed that \marxrsp
will not be installed.
\p
Assume that you want \marx installed in its own tree under
\tt{/opt/marx/\marx-fullversion/}.  This value is known as the
\em{installation-prefix}.  It is important to understand that with
this choice the resulting \marx executable will be placed in
\tt{/opt/marx/\marx-fullversion/bin/}.
\p
Now run the \tt{configure} script
specifying this value as the \tt{--prefix} argument:
#v+
    # ./configure --prefix=/opt/marx/4.5.0
#v-
If all has gone well, the last bit of output from the above command
should resemble:
#v+
    You are compiling MARX with the following compiler configuration:
       CC = gcc
          .
          .
       MARX parameter files will be installed in /opt/marx/4.5.0/share/marx/pfiles/.
            
       To continue the build process, run 'make'.
#v-
If not, then you may not have the necessary tools installed to compile
\marx, or you have an unsupported system.  If you are unable to
resolve the problem on your own, the contact \marx-email-address.
\p
Assuming all has gone well, execute the \tt{make} command:
#v+
    # make
#v-
(If this step fails and you are unable to resolve the problem, then
 contact \marx-email-address.)
\p
The final step in the installation process is to actually install the
compiled executables.  If you do not have write permission to the
installation-prefix directory (\tt{/opt/marx/\marx-fullversion} in this case),
then you will need to obtain the appropriate privileges to complete
the next step.  For example, this may require temporarily becoming the
\tt{root} user.  Now run
#v+
    # make install
#v-
to complete the installation.  As indicated above, the \marx
executable will be copied to \tt{/opt/marx/\marx-fullversion/bin/}.  As
such, it is recommended this directory be added to the user's
\tt{PATH} environment variable.  The install step will create the
following directories:
#d entry#2 \dtdd{\tt{$1}}{$2}
\begin{dl}
\entry{/opt/marx/\marx-fullversion/bin/}{Directory where \marx, \marx2fits,
  and other marx-related executables are placed.}
\entry{/opt/marx/\marx-fullversion/share/marx/data/}{Directory under which the
  marx calibration data files are located.}
\entry{/opt/marx/\marx-fullversion/share/marx/pfiles/}{The parameter files used
  by \marx are located here.}
\entry{/opt/marx/\marx-fullversion/share/doc/marx/}{Directory containing \marx{}-related
  documentation.}
\entry{/opt/marx/\marx-fullversion/lib/}{Static versions of libraries distributed
  with and used by \marx are put here.}
\entry{/opt/marx/\marx-fullversion/include/}{The C header files of the marx
libraries are put here.}
\entry{/opt/marx/\marx-fullversion/lib/marx/}{Contains miscellaneous marx-related
tools.}
\end{dl}

As the above indicates, the \marx data files will be copied to the
\tt{/opt/marx/\marx-fullversion/share/marx/data/} directory.  \Marx will
automatically search this directory for calibration files.  Also note
that the parameter files will be placed under
\tt{/opt/marx/\marx-fullversion/share/marx/pfiles/}.  As a helpful reminder, this
location is reported when \marx is invoked as \tt{marx --help}.

\p
The parameter files are
\bf{NOT} automatically loaded by \marx unless the \tt{UPARM} or
\tt{PFILES} environment variables are set appropriately.  For this
reason, it is recommended that the user copy these files to the
directory where the simulation will be performed.  
#i jdweb_end.tm
