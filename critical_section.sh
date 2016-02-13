#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

function critical_section_begin {
	local FILE=${1}
	local TIMEOUT=${2:-10}
	local LIST=($(ls /proc/self/fd))
	local MUTEX=$((${LIST[-1]}+1))
	eval "exec ${MUTEX}> ${FILE}"
	eval "echo ${MUTEX} 1>&${MUTEX}"
	flock -x -w ${TIMEOUT} ${MUTEX}
}

function critical_section_end {
	local FILE=${1}
	local MUTEX
	read MUTEX < ${FILE}
	flock -u ${MUTEX}
	eval "exec ${MUTEX}>&-"
}

# Unit Tests

ls /proc/self/fd 1>&2
LOCKFILE=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
critical_section_begin ${LOCKFILE}
	ls /proc/self/fd 1>&2
critical_section_end ${LOCKFILE}
ls /proc/self/fd 1>&2
rm ${LOCKFILE}
