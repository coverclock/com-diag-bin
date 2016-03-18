#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.
#
# USAGE
#
# critical_section_begin LOCKFILE
# critical_Section_end
#
# EXAMPLE
#
# critical_section_begin /var/run/$(basename $0)_mutex1
#	:
#	critical_section_begin /var/run/$(basename $0)_mutex2
#		:
#	critical_section_end
#	:
# critical_section_end
#
# ABSTRACT
#
# Implements critical sections in bash(1) scripts using flock(1).
#

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
		eval "echo ${BASHPID} 1>&${FD}"
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
		true
	else
		eval "COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}="
		false
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
