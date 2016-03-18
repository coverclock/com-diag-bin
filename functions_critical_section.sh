#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

function critical_section_begin {
	local FILE=${1}
	local LIST=($(ls /proc/self/fd))
	local FD=$((${LIST[-1]}+1))
	eval "exec ${FD}> ${FILE}"
	local WAIT=""
	if [[ -n "${2}" ]]; then
		WAIT="-w ${2}"
	fi
	if flock -x ${WAIT} ${FD}; then
		eval "echo $$ 1>&${FD}"
	else
		eval "exec ${FD}>&-"
		FD=""
	fi
	if [[ -z "${COM_DIAG_MUTEX_DEPTH}" ]]; then
		COM_DIAG_MUTEX_DEPTH=0
	fi
	COM_DIAG_MUTEX_DEPTH=$((${COM_DIAG_MUTEX_DEPTH} + 1))
	if [[ -n "${FD}" ]]; then
		eval "COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=${FD}"
		return 1
	else
		eval "COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}="
		return 0
	fi
}

function critical_section_end {
	if [[ -n "${COM_DIAG_MUTEX_DEPTH}" ]]; then
		eval "local FD=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		if [[ -n "${FD}" ]]; then
			flock -u ${FD}
			eval "exec ${FD}>&-"
		fi
		eval "COM_DIAG_MUTEX_FD_$$="
		COM_DIAG_MUTEX_DEPTH=$((${COM_DIAG_MUTEX_DEPTH} - 1))
	fi
}

function UNITTEST_0_critical_section {
	MUTEX1=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	MUTEX2=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	echo A0
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	critical_section_begin ${MUTEX1}
		echo B1
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		critical_section_begin ${MUTEX2}
			echo C2
			echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
			eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		critical_section_end
		echo B3
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	critical_section_end
	echo A4
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	rm -f ${MUTEX2}
	rm -f ${MUTEX1}
}

function UNITTEST_1_critical_section {
	MUTEX=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	ls /proc/self/fd 1>&2
	critical_section_begin ${MUTEX}
		ls /proc/self/fd 1>&2
	critical_section_end
	ls /proc/self/fd 1>&2
	rm ${MUTEX}
}

function UNITTEST_2_critical_section {
	MUTEX=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	(
		echo "A1"
		critical_section_begin ${MUTEX}
			echo "A2"
			sleep 5
			echo "A3"
		critical_section_end
		echo "A4"
	) &
	A=$!
	(
		echo "B1"
		critical_section_begin ${MUTEX}
			echo "B2"
			sleep 5
			echo "B3"
		critical_section_end
		echo "B4"
	) &
	B=$!
	wait ${B}
	echo "B0"
	wait ${A}
	echo "A0"
	rm ${MUTEX}
}
