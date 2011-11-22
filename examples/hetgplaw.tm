#i jdweb.tm
#i local.tm
#d pagename HETG-MARX Simulation - Powerlaw w/lines Example
#d xspec \href{http://heasarc.nasa.gov/xanadu/xspec/}{xspec}
#d sherpa \href{http://cxc.harvard.edu/sherpa/}{sherpa}


#% Changed/added definitions:

#d hetg \href{http://space.mit.edu/HETG/}{HETG}
#d file#1 \href{hetgplaw/$1}{$1}
#d myulitem#2 \item \bf{$1} - $2


#% Show a pretty picutre or two here...
\p
\begin{center}
\graphic_hw{hetgplaw/hpldisk_dispwide.png}{}{140}{}
\graphic_hw{hetgplaw/hplaw_FeHEG.png}{}{140}{}
\end{center}

\p
The purpose of this example, contributed by
\href{http://space.mit.edu/home/dd/}{Dan Dewey}, is to show how to use
\marx to simulate an \hetg observation of a point (and
simply-extended) source with a user-specified spectrum. User
customization for other \hetg - \marx applications should be
straightforward.

\p
After some \bf{Preliminaries}, the basic steps described in detail below are:

\ul
  {
    \myulitem{Create the spectal file}{Use \isis and standalone \tt{marxflux}
    to make a spectral input file for \marx.}

    \myulitem{Setup and run \marx}{Define and run the simulation to get a FITS event
    file; it can be viewed, e.g., with ds9.}

    \myulitem{Extract \hetg spectra}{Use standard \ciao tools, called conveniently
    from \isis scripts, to create pha2 and response files.}
    
    \myulitem{Perform spectral analysis}{Carry out model fitting in \isis,
    \sherpa, or \xspec using as input the pha2 and response files.}

  }

\p
Each of these steps is described in a text file that includes comments
and the command lines which can be cut-and-pasted; 
these files are displayed on this page as well.
The user is encouraged to download and use these files as starting
points for customization and recording ones own analysis steps.
Some screen shots from this example are given here as enticement:

\ul{
\item\href{hetgplaw/ss_spectrum.png}{Plotting the isis-created spectral
model.}  The spectra are shown on the PGPLOT window appearing above the isis command
window (lower left) and editor window (\href{http://www.jedsoft.org/jed/}{xjed}, lower right) where the 
isis_spectrum.txt file is being displayed and used as cut-ans-paste source.
\item\href{hetgplaw/ss_ds9marxboth.png}{Looking at marx-created FITS file
with ds9.}  The is from the marxcat'ed union of the point source simulation
and the disk simulation.
\item\href{hetgplaw/ss_disk_Plt_imsp.png}{Dispersed spectral images from
disk simulation.}  Looking at the Plt_imsp.ps file created as one of the
summary plots in the isis-scripted ciao processing.
\item\href{hetgplaw/ss_counts_spectra.png}{The four first-order spectra
dispayed in ISIS.}  Note that the line regions are indicated (gray) and will
be excluded in continuum fitting.
\item\href{hetgplaw/ss_continuum_fit.png}{Continuum fitting of the spectra.}
The four counts spectra are jointly fit with the continuum model; residuals
in chi are shown as well.
\item\href{hetgplaw/ss_point_Fe_fit.png}{Fitting Fe line to HEG spectra.}  A
Gaussian line is jointly fit to the two HEG spectra and conficence limits
on its width are reported.  This shows the output of running the
isis_analysis.txt script.
}

\p
\sect{Preliminaries}

\p
The steps below are performed in a linux-like environment
with installed versions of
\marx, \isis, and \ciao in the search path(*).  Unless indicated
otherwise, commands are carried out
in a ``\bf{working directory}'' that the user has
write privilege in, e.g., \tt{/nfs/mycomputer/d1/AGN_amazing/hetg_simulations/} .

\p
Add the following to the ``working directory'': 
\ul
{

\myulitem{marxflux}{The \file{marxflux} file (click it to download).  Then do a
\tt{chmod a+x marxflux} to ensure that it can be executed.}

\myulitem{TG-Cat reprocessing scripts}{Download the file
\file{TGCat_scripts.tar} to the ``working directory'' and do
a ``\tt{tar -xvf TGCat_scripts.tar}'' which will create and fill a ``scripts''
sub-directory.  Go into the scripts directory (\tt{cd scripts/}) and do a
``\tt{cat badpix_NULL.sl >> tg_repro_fun.sl}'' (This step appends
a redefinition of a procedure so that no badpix
files are used in the \marx simulation processing.)
Back in the working directory (\tt{cd ..}) the TGCat_scripts.tar file can be
removed (\tt{rm TGCat_scripts.tar}).\newline
Thanks to Dave Huenemoerder for making these ``TGCat scripts'' available
ahead of their release.}

\myulitem{marx_orig.par}{Copy fresh versions of the marx parameter files
into the working directory;  doing ``\tt{[unix] marx --help}''
will show the location of the marx parameter files.
Also do a \newline
``\tt{cp marx.par marx_orig.par}''\newline
to save the original marx.par file to use as a starting point in
simulation scripts.}

}

\p
Now, multiple simulations and analyses can be carried out in this
``working directory'' without redoing these steps above. FYI, the directory
now contains:
#v+
[unix] ls
marxasp.par  marxflux  marx_orig.par  marx.par  marxpileup.par  scripts
#v-


\p \center{\em{
(*) Note that in some installations it can happen that \ciao and stand-alone
\newline 
\isis may have conflicts.  In these cases it is useful to only ``setup'' \ciao when needed
\newline
(the third step) and then restart a new window when done with \ciao processing.
}}


\sect{Create the spectral file}

\p The following instructions are in \file{isis_spectrum.txt}.

#v+
#i hetgplaw/isis_spectrum.txt
#v-


\sect{Setup and run \marx}

\p The following instructions are in \file{marx_hetg_plaw.txt}.

#v+
#i hetgplaw/marx_hetg_plaw.txt
#v-


\sect{Extract \hetg spectra}

\p The following instructions are in \file{ciao_marx_process.txt}.

#v+
#i hetgplaw/ciao_marx_process.txt
#v-


\sect{Perform spectral analysis}

\p The following instructions are in \file{isis_analysis.txt}.

#v+
#i hetgplaw/isis_analysis.txt
#v-


#i jdweb_end.tm

