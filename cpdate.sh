#!/bin/bash
# Copyright 2005-2014 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.
# Make a timestamped backup copy of a file.

USAGE="`basename $0` file [ directory ]"
TS="`date -u +%Y%m%dT%H%M%SZ%N`"
if [ 1 -le $# -a $# -le 2 ]; then
    if [ -f $1 ]; then
        if [ $# -eq 1 ]; then
            TO="$1-$TS"
            exec cp -i $1 $TO && chmod u-wx,g-wx,o-wx $TO
        elif [ -d $2 ]; then
            BN="`basename $1`"
            TO="$2/$BN-$TS"
            exec cp -i $1 $TO && chmod u-wx,g-wx,o-wx $TO
        fi
    fi
fi
echo "$USAGE" 1>&2
exit 1
