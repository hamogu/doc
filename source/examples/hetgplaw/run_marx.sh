#!/bin/sh

. ../config.inc
PATH="$MARXPREFIX/bin:$PATH"

cp $MARXPREFIX/share/marx/pfiles/*.par .

. ./run_marx_point.inc
. ./run_marx_disk.inc
. ./run_marx2fits.inc
