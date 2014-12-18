#!/bin/bash
if [ $# -ne 2 ]; then
    echo "usage: $0 CHANGELIST PREFIX" 1>&2
    exit 1
fi
CHANGELIST="$1"
PREFIX="$2"
p4 describe -s ${CHANGELIST} | grep "^\.\.\." | sed -e "s|^\.\.\. ${PREFIX}||" | sed -e 's/#.*$//'
