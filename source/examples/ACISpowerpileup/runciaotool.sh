#!/bin/sh 
unset DISPLAY
. /nfs/cxc/a1/setup/ciao-setup.sh > /dev/null
"$@"
