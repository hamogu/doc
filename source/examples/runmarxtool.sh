#!/bin/sh

# config.inc is in the same directory as this script, but it needs to be given
# relative to the directory where this script is *called*, which will always be a
# subdirectory of examples, thus ../config.inc instead of ./config.inc
. ../config.inc
PATH="$MARXPREFIX/bin:$PATH"

"$@"