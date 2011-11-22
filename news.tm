#i jdweb.tm
#i local.tm
#d pagename \Marx 5 Highlights

\Marx 5 is a major new release.  This page is devoted to the new
features.

#d section#2 \hline\center{\h1{\label{toc-$1} $2}}\hline

#d sect-aspect Subpixel Randomization
#d sect-dither New Dither Model
\h1{\bf{Contents}}
 \href{#toc-1}{\sect-aspect} \newline
 \href{#toc-1}{\sect-dither} \newline

\section{1}{\sect-aspect}
The EDSER subpixel algorithm was incorporated into CIAO 4.3.  When
computing Sky coordinates, \tt{acis_process_events} first converts the
integer-valued chip coordinate to a floating point value.  There are
several ways in which this may be done.  One way is to simply cast the
integer to a float, e.g,, the integer 2 becomes 2.0.  The problem with
this approach is that it can cause aliasing artifacts in the resulting
Sky image.  For this reason, the default up until CIAO 4.3 was to
simply add a uniform random deviate from -0.5 to 0.5 to the integer
value so that 2 would become a random real number in the semi-open
interval [1.5, 2.5).  The default was changed in CIAO 4.3 to use a
probability distribution based upon flight grade and energy, known as
the EDSER method.

The \marx 5 version of \marx2fits introduces a \tt{--pixadj} command
line parameter that allows the user to select one of several pixel
randomization methods.  Simply running \marx2fits without any command
line arguments will display its usage message:
#v+
marx2fits v5.0.0:
Usage: marx2fits [options] marxdir outfile
Options:
  --pileup             Process a marxpileup simulation
  --pixadj=EDSER       Use a subpixel algorithm (default)
  --pixadj=RANDOMIZE   Randomize within a detector pixel
  --pixadj=NONE        Do not randomize withing a detector pixel
  --pixadj=EXACT       Use exact chip coordinates
#v-
\p
The effect of these randomization methods may be seen in the following
plot, which shows that the EDSER distribution approaches the
exact limit.
\p
\center{\img{marxsubpix.png}{Image of PSF with different pixadj values}}

\section{2}{\sect-dither}

The EDSER subpixel algorithm necessatated numerous changes to the
\marx aspect code.  In particular, aspect reconstruction blur
had to be cleanly separated into its independently contributing
pieces, namely the telescope pointing uncertainty, the blur introduced
by pixel quantization/truncation, and the blur associated with pixel
randomization.  Previous versions of \marx incorporated these blurs
under the guise of a single parameter, \tt{DitherBlur}, whose value
was the RSS sum of the contributing blurs.  This was the source of a
lot of confusion among users resulting in numerous help desk inquiries
about how this value was obtained and why it was so large.
For these reasons, the \tt{DitherBlur} parameter was removed for \marx
and replaced by one called \tt{AspectBlur} whose value represents
just the telecope pointing uncertainty,
\href{http://cxc.harvard.edu/cal/ASPECT/img_recon/report.html}{0.07
arc-seconds}.
\p
It was also necessary to remove the blur parameters from \marxasp,
which computes an aspect solution file for use in reprocessing a
\marx2fits generated event file.  Hence any scripts that pass blur
parameter values to \marxasp will need to be modified.

#i jdweb_end.tm
