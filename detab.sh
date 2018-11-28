#/bin/bash
# vi: set ts=4:
# Copyright 2018 Digital Aggregates Corporation.
# Licensed under the terms in LICENSE.txt.

ZERO=$(basename ${0})
TEMP=$(mktemp ${TMPDIR:="/tmp"}/${ZERO}.XXXXXXXXXX)
TABS=4

if [ "$1" = "-t" ]; then
	shift
	TABS=$2
	shift
fi

for FILE in $*; do
	echo ${FILE} ${TABS}
	if true; then
		:
	elif expand -i -t ${TABS} < ${FILE} > ${TEMP}; then
		mv ${TEMP} ${FILE}
	else
		exit 1
	fi
done

exit 0
