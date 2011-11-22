# -*- sh -*-

TOPDIR = ../..
LOCAL_INCLUDE_DIR=$(TOPDIR)/include
OTHER_DEPS = ../local.tm
INSTALL_ROOT_DIR = /nfs/space/web/ASC/marx-4.5
INSTALL_SUB_DIR = examples

HTML = index.html powerlaw.html pileup.html ciao.html aped.html hetgplaw.html

POWERLAW_INSTALL_FILES = powerlaw/plawfit.png powerlaw/plaw.p \
 powerlaw/plawflux.tbl powerlaw/marx.par powerlaw/plaw_ciao.sh \
 powerlaw/pileup_ciao.sh powerlaw/plawpileupfit.png \
 aped/apedfun.sl aped/apedflux.tbl aped/apedflux.png aped/apedmeg1.png \
 aped/MEG_ds9sls_osort.png
HETGPLAW_INSTALL_FILES = hetgplaw/*

OTHER_INSTALL_FILES = marxflux $(POWERLAW_INSTALL_FILES) \
  ${HETGPLAW_INSTALL_FILES}

include $(TOPDIR)/include/Makefile.inc
