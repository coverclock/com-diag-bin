#!/bin/bash
if [ $# -ne 2 ]; then
    echo "usage: $0 CHANGELIST WORKSPACE" 1>&2
    exit 1
fi
CHANGELIST="$1"
WORKSPACE="$2"
p4collab addchangelist ${P4PORT} ${P4USER} ${WORKSPACE} ${CHANGELIST}
