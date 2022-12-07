#!/bin/bash
# Copyright 2022 by the Digital Aggregates Corporation, Colorado, USA.
# Creates a compressed tar file of the modified files in this git repo.
PROGRAM=$(basename ${0})
TMPFIL=$(mktemp $(readlink -f ${TMPDIR:="/tmp"}/${PROGRAM%.sh}.XXXXXXXXXX))
trap "rm -f ${TMPFIL}" 0 1 2 3 15
git status | grep '^[ 	]*modified:[ 	]*' | sed 's/^[ 	]*modified:[ 	]*//' > ${TMPFIL}
tar -cvz -T ${TMPFIL} -f -
