# -*- sh -*-

INSTALL_ROOT_DIR = /nfs/space/web/ASC/marx-5.0

OTHER_INSTALL_TARGETS = install_subdirs
LOCAL_INCLUDE_DIR=../include
OTHER_DEPS = ./local.tm

HTML = index.html install.html docs.html \
       faqs.html caveats.html psf.html news.html

OTHER_INSTALL_FILES = anim_1878_chart.gif anim_1878_marx.gif marxsubpix.png
OTHER_ALL_TARGETS = examples

include ../include/Makefile.inc


install_subdirs:
	cd examples; make install
examples:
	cd examples; $(MAKE)
clean_examples:
	cd examples; $(MAKE) clean
clean-all: clean clean_examples
install-all: install install_subdirs

.PHONY: examples clean_examples clean-all install-all
