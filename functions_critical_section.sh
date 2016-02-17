#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

function critical_section_begin {
	local FILE=${1}
	local WAIT=${2:-10}
	local LIST=($(ls /proc/self/fd))
	local FD=$((${LIST[-1]}+1))
	eval "exec ${FD}> ${FILE}"
	flock -x -w ${WAIT} ${FD}
	eval "echo ${FD} 1>&${FD}"
}

function critical_section_end {
	local FILE=${1}
	local FD
	read FD < ${FILE}
	flock -u ${FD}
	eval "exec ${FD}>&-"
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
