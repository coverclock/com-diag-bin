#/bin/bash
# vi: set ts=4:
# Copyright 2018 Digital Aggregates Corporation.
# Licensed under the terms in LICENSE.txt.
# usage: $0 [ -t TAB ] FILE [ ... ]

ZERO=$(basename ${0})
TEMP=$(mktemp ${TMPDIR:="/tmp"}/${ZERO}.XXXXXXXXXX)
TABS=4

if [ "$1" = "-t" ]; then
	shift
	TABS=$1
	shift
fi

for FILE in $*; do
	if expand -i -t ${TABS} < ${FILE} > ${TEMP}; then
		mv ${TEMP} ${FILE}
	else
		exit 1
	fi
done

exit 0
