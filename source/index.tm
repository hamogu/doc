#i jdweb.tm
#i local.tm
#d pagename MARX Home Page

#d marx-technical-manual \href{\marx-manual-url}{Marx Technical Manual}

[\tt{2012-01-27}] \Marx \marx-version was released.  See the
\href{install.html}{Download/Install page} for links to the \marx source
code.  See the \href{news.html}{Release Notes} for important
information about this release.

\p
\Marx is a suite of programs created and maintained by the
\href{http://space.mit.edu/cxc/}{MIT/CXC/HETG} group and is designed
to enable the user to simulate the on-orbit performance of the Chandra
X-ray Observatory. \Marx provides a detailed ray-trace
simulation of how Chandra responds to a variety of astrophysical
sources and can generate standard FITS event files and images as
output. It contains detailed models for Chandra's High Resolution
Mirror Assembly (HRMA), the HETG and LETG gratings, and all the focal
plane detectors.

\p
If you publish any work that made use of \marx, please cite the
paper
\href{http://adsabs.harvard.edu/abs/2012SPIE.8443E..1AD}{Raytracing
with MARX: x-ray observatory design, calibration, and support}.

#% \hline

#% \h2{\center{Marx-\marx-version Highlights}}

#% \begin{ulist}
#% \item
#%  The \marx ACIS spatial contamination model has been updated to be
#%   consistent with that of the latest Chandra CALDB (specifically,
#%   \tt{acisD1999-08-13contamN0005.fits}).

#% \item
#%  If the \tt{marx.par} parameter \tt{NumRays} is set to a negative value, then
#%  the simulation will continue until at least \tt{|NumRays|} photons have
#%  been detected.
#% \end{ulist}

#i jdweb_end.tm

