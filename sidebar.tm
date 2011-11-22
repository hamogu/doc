#i local.tm

#i colorthemes/blue1.tm
#d pre_style_border 1px dashed \sidebar_bg_color
#d pre_style_bg_color #F9F9F9

#d sidebar_cellpadding 4
#d sidebar_width 15%
#d body_width 85%

#%\sidebar_label{Site Map}
\sidebar_link{index.html}{Marx Home}
\sidebar_link{install.html}{Download/Install}
\sidebar_link{docs.html}{Documentation}
\sidebar_link{examples/index.html}{Examples}
\sidebar_link{caveats.html}{Caveats}
\sidebar_link{faqs.html}{FAQs}

\sidebar_text{\hline}

#%\sidebar_link{\isis_home}{isis}
\sidebar_link{http://space.mit.edu/cxc/}{CXC@MIT}
\sidebar_link{\chandra_home}{Chandra}


#% These lines are optional.  They are used to override the default
#% table parameters

#%d bar_color #ffff99
#%d bar_color #d5d7d9
#%d sidebar_bg_color \bar_color
#%d sidebar_text_bg \bar_color
#%d top_bg \body_bg

#d jdweb_end_html <hr>\p{class="jdwebend"} \
  \table{100%}{}{ \
    \tr{\td{}{align=left}{<font size="-1">\lastupdated<br>\emailme</font>} \
        \td{}{align=right}{\checkhtml \madewithjed \anybrowser}}}

