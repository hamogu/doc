#i jdweb.tm
#i local.tm
#d pagename Basic Setup

These pages provide a few \marx examples.  All of the examples assume
that you are working in a directory where you have write permission
and enough disk space for the simulation.  It is also assumed that the
\marx executables are on the search path and that the marx parameter
files (\tt{marx.par}, \tt{marxasp.par},
\tt{marxpileup.par}) are located in the current directory.  Assuming
that \marx has been \href{../install.html}{properly installed}, the
latter requirement may be accomplished by running \marx via
#v+
  unix% marx --help
    .
    .
  marx parameter files may be found in:
   /opt/marx4.4/share/marx/pfiles/
#v-
Simply copy the files from the indicated directory to the current one:
#v+
  unix% cp /opt/marx4.4/share/marx/pfiles/*.par .
#v-

#i jdweb_end.tm

