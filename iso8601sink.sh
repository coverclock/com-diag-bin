#!/bin/bash
# Copyright 2018 by the Digital Aggregates Corporation, Colorado, USA.
export IFS=""
while read BUFFER; do
	echo $(date -u +%Y-%m-%dT%H:%M:%S.%N+00:00) ${BUFFER}
done
