#i jdweb.tm
#i local.tm
#d pagename \Marx 5 Highlights
#d saotrace \href{http://cxc.harvard.edu/chart/index.html}{SAOTrace}

\Marx 5 is a major new release.  This page is devoted to the new
features.

#d section#2 \hline\center{\h1{\label{toc-$1} $2}}\hline

#d sect-aspect Subpixel Randomization
#d sect-dither New Dither Model
#d sect-calibration Calibration Updates
#d sect-marxpar Marx Parameter File Updates

\h1{\bf{Contents}}
 \href{#toc-1}{\sect-aspect} \newline
 \href{#toc-2}{\sect-dither} \newline
 \href{#toc-3}{\sect-calibration} \newline
 \href{#toc-4}{\sect-marxpar} \newline

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
discrete probability distribution based upon flight grade and energy, known as
the EDSER method.

\p
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
  --pixadj=NONE        Do not randomize within a detector pixel
  --pixadj=EXACT       Use exact chip coordinates
#v-
\p
The effect of these randomization methods may be seen in the following
plot, which shows that the EDSER distribution approaches the
exact limit.
\p
\center{\img{marxsubpix.png}{Image of PSF with different pixadj values}}

\p
If using \saotrace rays with \marx, see the
\href{caveats.html}{important caveat} regarding the use of the EDSER
method with such rays.

\section{2}{\sect-dither}

The EDSER subpixel algorithm necessitated numerous changes to the
\marx aspect code.  In particular, aspect reconstruction blur
had to be cleanly separated into its independently contributing
pieces, namely the telescope pointing uncertainty, the blur introduced
by pixel quantization/truncation, and the blur associated with pixel
randomization.  Previous versions of \marx incorporated these blurs
under the guise of a single parameter, \tt{DitherBlur}, whose value
was the RSS sum of the contributing blurs.  This was the source of a
lot of confusion among users resulting in numerous help desk inquiries
about how this value was obtained and why it was so large.
For these reasons, the \tt{DitherBlur} parameter was removed from \marx
and replaced by one called \tt{AspectBlur} whose value represents
just the telescope pointing uncertainty,
\href{http://cxc.harvard.edu/cal/ASPECT/img_recon/report.html}{0.07
arc-seconds}.  One consequence of this change is that \marx 4.x
parameter files cannot be used with marx 5.0.

\p
It was also necessary to remove the blur parameters from \marxasp,
which computes an aspect solution file for use in reprocessing a
\marx2fits generated event file.  Hence any scripts that pass blur
parameter values to \marxasp will need to be modified.

\section{3}{\sect-calibration}
\p
As mentioned above, the \tt{DitherBlur} parameter's value reflected
more that just that associated with the aspect uncertainty.  It was
also tweaked to get the marx PSF to better match Chandra grating line
profiles.  With this parameter gone, the \marx HRMA blur parameters
had to be re-calibrated to get the widths of the \marx simulated
grating line profiles to match those in the Chandra CALDB.
\p
There was a long standing issue of a relative rotation between the
LETG and the ACIS detector.  The root of this problem was tracked down
(with the help of \marx) to a rotation offset between the aspect
coordinate system and the focal plane detector system.  This offset
was masked by compensating rotations of the detectors from astrometric
analysis, and manifested itself as a small rotation of the LEG
dispersion arm on the ACIS detector.  Changes were added to CIAO 4.3
that effectively adds an additional rotation to the LETG when used
with ACIS.  The corresponding change in \marx 5.0 is implemented via a
new parameter called \tt{LETG_ACIS_dTheta}.
\p
The \marx calibration data have been brought up to date with the
Chandra CALDB 4.4.7.
\section{4}{\sect-marxpar}
\p
The parameter files for earlier versions of marx (e.g., the marx.par
file for version 4.5) cannot be used with marx 5.0.  The recalibrations
that were necessary for subpixel support resulted in changes to all of
the HRMA blur parameters, as well as the introduction of the new
\tt{AspectBlur} parameter discussed above.
\p
The following marx.par parameter values have changed since marx 4.5:
#v+
 P1Blur: 0.18129215 --> 0.303427
 H1Blur: 0.13995037 --> 0.0051428
 P3Blur: 0.11527828 --> 0.0951899
 H3Blur: 0.16360829 --> 0.0713614
 P4Blur: 0.1289134 --> 0.178899
 H4Blur: 0.098093014 --> 0.0101367
 P6Blur: 0.076202759 --> 0.151085
 H6Blur: 0.079767401 --> 0.0239287
 MEGRowlandDiameter: 8632.65 --> 8632.48
 HEGRowlandDiameter: 8632.65 --> 8632.48
 HETG_Shell1_Period: 0.400141 --> 0.400195
 HETG_Shell3_Period: 0.400141 --> 0.400195
 LETG_Shell1_Theta: -0.07 --> 0.07
 LETG_Shell3_Theta: -0.07 --> 0.07
 LETG_Shell4_Theta: -0.07 --> 0.07
 LETG_Shell6_Theta: -0.07 --> 0.07
 legCoarseNumOrders: 11 --> 121
#v-
The following parameters have been removed:
#v+
 DitherBlur
#v-
The following parameters have been added:
#v+
 AspectBlur: 0.07
 LETG_ACIS_dTheta: -0.0867
 Use_This_Order: 0
 DetExtendFlag: no
#v-
The latter two parameters were added for the purposes of calibration.
#i jdweb_end.tm
