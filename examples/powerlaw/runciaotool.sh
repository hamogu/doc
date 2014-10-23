#!/bin/sh 
unset DISPLAY
. $ASC/setup/ciao-setup.sh > /dev/null
"$@"
