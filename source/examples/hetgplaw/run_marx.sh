#!/bin/sh

. ../config.inc
PATH="$MARXPREFIX/bin:$PATH"

cp $MARXPREFIX/share/marx/pfiles/*.par .

# Wrap these in runciaotool to make sure the "pset" is available.
../runciaotool.sh ./run_marx_point.inc
../runciaotool.sh ./run_marx_disk.inc
. ./run_marx2fits.inc
