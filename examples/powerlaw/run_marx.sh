#!/bin/sh

. ../config/config.inc
PATH="$MARXPREFIX/bin:$PATH"

cp $MARXPREFIX/share/marx/pfiles/*.par .

. inc/runmarx.inc
. inc/runmarx2fits.inc
. inc/runmarxasp.inc
