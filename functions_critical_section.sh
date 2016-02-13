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

function UNITTEST_1_critical_section {
	LOCKFILE=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	ls /proc/self/fd 1>&2
	critical_section_begin ${LOCKFILE}
	ls /proc/self/fd 1>&2
	critical_section_end ${LOCKFILE}
	ls /proc/self/fd 1>&2
	rm ${LOCKFILE}
}

function UNITTEST_2_critical_section {
	LOCKFILE=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	(
		echo "A1"
		critical_section_begin ${LOCKFILE}
			echo "A2"
			sleep 5
			echo "A3"
		critical_section_end ${LOCKFILE}
		echo "A4"
	) &
	A=$!
	(
		echo "B1"
		critical_section_begin ${LOCKFILE}
			echo "B2"
			sleep 5
			echo "B3"
		critical_section_end ${LOCKFILE}
		echo "B4"
	) &
	B=$!
	wait ${B}
	echo "B0"
	wait ${A}
	echo "A0"
	rm ${LOCKFILE}
}
