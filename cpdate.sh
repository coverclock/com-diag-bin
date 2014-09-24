#!/bin/bash
# Copyright 2005-2014 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.
#       
#   cppdate.sh: make a timestamped backup copy of a file.
#
#   usage:  cpdate <filename>
#   or      cpdate <filename> <directory>
#

USAGE="`basename $0` file [ directory ]"
TS="`date -u +%Y%m%dT%H%M%S.%N%:z`"
if [ 1 -le $# -a $# -le 2 ]; then
    if [ -f $1 ]; then
        if [ $# -eq 1 ]; then
            TO="$1-$TS"
            cp -i $1 $TO && chmod u-wx,g-wx,o-wx $TO
            exit $?
        elif [ -d $2 ]; then
            BN="`basename $1`"
            TO="$2/$BN-$TS"
            cp -i $1 $TO && chmod u-wx,g-wx,o-wx $TO
            exit $?
        fi
    fi
fi
echo "$USAGE" 1>&2
exit 1
