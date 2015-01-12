#!/bin/sh

. ../config.inc
PATH="$MARXPREFIX/bin:$PATH"

cp $MARXPREFIX/share/marx/pfiles/*.par .

. ./runmarx.inc
. ./runmarx2fits.inc
. ./runmarxasp.inc
