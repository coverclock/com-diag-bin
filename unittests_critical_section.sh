#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

. $(dirname $(basename $0))/functions_critical_section.sh

################################################################################

function UNITTEST_0_com_diag_critical_section {
	MUTEX1=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	MUTEX2=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	echo A0
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	com_diag_critical_section_begin ${MUTEX1}
		echo B1
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		com_diag_critical_section_begin ${MUTEX2}
			echo C2
			echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
			eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		com_diag_critical_section_end
		echo B3
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	com_diag_critical_section_end
	echo A4
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	rm -f ${MUTEX2}
	rm -f ${MUTEX1}
}

echo "UNITTEST_0_com_diag_critical_section"
UNITTEST_0_com_diag_critical_section

################################################################################

function UNITTEST_1_com_diag_critical_section {
	MUTEX=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	ls /proc/self/fd 1>&2
	com_diag_critical_section_begin ${MUTEX}
		ls /proc/self/fd 1>&2
	com_diag_critical_section_end
	ls /proc/self/fd 1>&2
	rm -f ${MUTEX}
}

echo "UNITTEST_1_com_diag_critical_section"
UNITTEST_1_com_diag_critical_section

################################################################################

function UNITTEST_2_com_diag_critical_section {
	MUTEX=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	(
		echo "A1"
		com_diag_critical_section_begin ${MUTEX}
			echo "A2"
			echo "OWNER=$(cat ${MUTEX})"
			sleep 5
			echo "A3"
		com_diag_critical_section_end
		echo "A4"
	) &
	A=$!
	(
		echo "B1"
		com_diag_critical_section_begin ${MUTEX}
			echo "B2"
			echo "OWNER=$(cat ${MUTEX})"
			sleep 5
			echo "B3"
		com_diag_critical_section_end
		echo "B4"
	) &
	B=$!
	wait ${B}
	echo "B0"
	wait ${A}
	echo "A0"
	rm -f ${MUTEX}
}

echo "UNITTEST_2_com_diag_critical_section"
UNITTEST_2_com_diag_critical_section

################################################################################

function UNITTEST_3_com_diag_critical_section {
	MUTEX=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	echo A0
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	com_diag_critical_section_begin ${MUTEX} 10
		echo B1
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		com_diag_critical_section_begin ${MUTEX} 10
			echo C2
			echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
			eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		com_diag_critical_section_end
		echo B3
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	com_diag_critical_section_end
	echo A4
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	rm -f ${MUTEX}
}

echo "UNITTEST_3_com_diag_critical_section"
UNITTEST_3_com_diag_critical_section

################################################################################

function UNITTEST_4_com_diag_critical_section {
	MUTEX=$(mktemp /tmp/$(basename $0).XXXXXXXXXX)
	echo A0
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	if com_diag_critical_section_begin ${MUTEX} 10; then
		echo B1
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		if com_diag_critical_section_begin ${MUTEX} 10; then
			echo C2
			echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
			eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
			com_diag_critical_section_end
		fi
		echo B3
		echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
		eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
		com_diag_critical_section_end
	fi
	echo A4
	echo COM_DIAG_MUTEX_DEPTH=${COM_DIAG_MUTEX_DEPTH}
	eval "echo COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}=\$COM_DIAG_MUTEX_FD_${COM_DIAG_MUTEX_DEPTH}"
	rm -f ${MUTEX}
}

echo "UNITTEST_4_com_diag_critical_section"
UNITTEST_4_com_diag_critical_section

################################################################################
