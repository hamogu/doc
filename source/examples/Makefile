# -*- sh -*-

TOPDIR = ../..
LOCAL_INCLUDE_DIR=$(TOPDIR)/include
OTHER_DEPS = ../local.tm
INSTALL_ROOT_DIR = /nfs/space/web/ASC/marx-5.0
INSTALL_SUB_DIR = examples

HTML = index.html powerlaw.html pileup.html ciao.html aped.html \
  hetgplaw.html letgplaw.html

POWERLAW_INSTALL_FILES = powerlaw/plawfit.png powerlaw/plaw.p \
 powerlaw/plawflux.tbl powerlaw/marx.par powerlaw/plaw_ciao.sh \
 powerlaw/pileup_ciao.sh powerlaw/plawpileupfit.png \
 aped/apedfun.sl aped/apedflux.tbl aped/apedflux.png aped/apedmeg1.png \
 aped/MEG_ds9sls_osort.png

LETGPLAW_INSTALL_FILES = letgplaw/letgplaw.p \
 letgplaw/letgplaw_fit_m1.png letgplaw/letgplaw_fit_p1.png \
 letgplaw/letgplaw_fit_m1_kev.png letgplaw/letgplaw_fit_p1_kev.png \
 letgplaw/LEG_ds9sls_osort.png letgplaw/rgbimage.png \
 letgplaw/letgplaw_ciao.sh letgplaw/letgplawflux.tbl

HETGPLAW_INSTALL_FILES = hetgplaw/*

OTHER_INSTALL_FILES = marxflux $(POWERLAW_INSTALL_FILES) \
  ${HETGPLAW_INSTALL_FILES} ${LETGPLAW_INSTALL_FILES}

include $(TOPDIR)/include/Makefile.inc
