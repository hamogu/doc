#i jdweb.tm
#d pagename MARX Frequently Asked Questions
#i faqmacros.tm

#% #d question#1 \hline\h1{$1}\p
#d cxc-help-desk \href{http://asc.harvard.edu/helpdesk/index.html}{CXC Helpdesk}

\faq{I have a question about marx that is not addressed here.
Where can I get additional help?}{

\Marx{}-specific questions should be sent to \marx-email-address.  If
your question is \ciao{}-related, then you should contact the
\cxc-help-desk.
}

\faq{Do you distribute marx binaries?}{
No.  There are several reasons for this including the lack of
resources.  Rather, we have tried to make the installation process as
simple as possible so that even the most inexperienced user can do it.
Step by step instructions for compiling \marx are available on the
\href{install.html}{installation page}.  The reward for compiling it
yourself is that you can be sure that \marx was built explicitly for
your system, and as such, no incompatibilities should arise.  One
cannot make this guarantee for a precompiled binary version.
}

\faq{How do I create an ARF and RMF that match my marx simulation?}{

The answer to this question may be found
\href{examples/ciao.html}{here}.
}

\faq{Can I simulate arbitrary combinations of ACIS CCDs in marx?}{

The simple answer is "no". Out of the box, \marx allows users to
select either the ACIS-S array (6 CCDs) or the ACIS-I array (4 CCDs).
Arbitrary mixtures of chips from the two arrays are not currently
supported although we plan to add that option in a future version
of \marx.

\p
In the meantime, if you do need to simulate other combinations,
one can assemble such composites by creating the desired ACIS-S 
and ACIS-I chips separately and them merging the resulting event
lists with the \ciaotool{dmmerge} tool in \ciao. For such mergers, both pieces
of the simulation must have the same aimpoint position. 
This configuration can be accomplished by a SIM translation in \marx
using the \tt{DetOffsetX} and \tt{DetOffsetZ} parameters.

\p
For example, to create a \marx simulation where the default
ACIS-S aimpoint was used, but ACIS-I chips were also active
during the observation, one would do two separate simulations.
The ACIS-S portion of the simulation would utilize the \marx defaults.
The simulation of the ACIS-I chips however would require moving
the SIM to position the ACIS-I detector correctly relative to the
default ACIS-S aimpoint. The appropriate values in the \tt{marx.par} file 
would be:
#v+
  DetOffsetX=0.0990000
  DetOffsetZ=43.4590
#v-
\p 
Note that the DetOffsetY parameter is not modified since SIM motion
along the Y axis is not permitted. For simulations using the default
ACIS-I aimpoint, the ACIS-S simulation would need to be offset
using the values:
#v+
  DetOffsetX=-0.0990000
  DetOffsetZ=-43.4590
#v-

\p
The \ciaotool{dmmerge} tool will produce some warning messages during the
combination of the two event lists, but should produce a valid
FITS event file. Unwanted CCDs can be removed using \ciaotool{dmcopy}.
}

\faq{Can I simulate CTI-corrected observations in marx?}{

No. \marx does not currently recognize the new format
of the CTI-corrected FEF file available in the CALDB (versions 2.18
and higher). So simulations cannot be created directly
which feature the improved spectral response of the front-illuminated
CCDs after CTI correction. Users wishing to simulate CTI--corrected
spectra can however use the \bf{marxrsp} tool to fold a given \marx
simulation through an existing RMF created from the CTI--corrected FEF. 
}

\faq{Is it possible to run marx with a constant effective area?}{

If by ``constant'' you mean an effective area that does not not depend
upon energy, then the answer is yes.   To do so, use the following
configuration:
#v+
  DetIdeal=yes
  HRMA_Ideal=yes HRMAVig=1.0
  Use_Unit_Efficiencies=yes
  mode=h
#v-
The \tt{DetIdeal=yes} setting tells \marx to assume that the detectors
have 100 percent quantum efficiency.  The line involving the
\tt{HRMA*} parameters indicates that perfect reflectivity from the
mirrors is to be assumed and that no rays will suffer vignetting from
the various baffles.  The \tt{Use_Unit_Efficiencies=yes} parameter
setting comes into play only in when the gratings (LETG or HETG)
are used.  It causes the diffraction efficiencies for all orders to
be equal, i.e., all diffraction orders will be equally probable.
Finally, the \tt{mode=h} line will cause \marx to not save these
values in the \tt{marx.par} file.
\p
Keep in mind that some photons will still be lost if they scatter from
the mirror and not hit the detector, fall in detector gaps, etc.
}


#% ---------------------------------------------------------------------------
#% End of FAQs
#% ---------------------------------------------------------------------------

\h2{Questions}

\faq_questions

\h2{Answers}

\faq_answers


#i jdweb_end.tm
