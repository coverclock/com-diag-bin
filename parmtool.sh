#!/bin/bash
# vi: set ts=4:
# Copyright 2015-2016 Digital Aggregates Corporation.
# Licensed under the terms of the GPLv2.
# WORK IN PROGRESS
#
# USAGE
#
# parmtool [ -L | -l | -a | -A COMMAND | -r KEYWORD | -d KEYWORD | [ -m MODE ] [ -w KEYWORD=VALUE | -W KEYWORD=VALUE | -u KEYWORD=VALUE | -U KEYWORD=VALUE ] | -C | -c ]
#
# OPTIONS
#
# EXAMPLE
#
# ABSTRACT
#

ZERO=`basename $0`

ROOTETC=${PARMTOOLETC:-"${HOME}/.parmtool/db"}
ROOTRUN=${PARMTOOLRUN:-"/var/tmp/${LOGNAME}/.parmtool/db"}
CAT=${PARMTOOLCAT:-"cat"}
MODE=${PARMTOOLMODE:-""}

RC=0

function parmtool_consumer {
	local KEYWORD="${1}"
	local VALUE=""
	local LATCH=0
	while true; do
		if read VALUE; then
			echo "${KEYWORD} = ${VALUE}"
			VALUE=""
			LATCH=1
		elif [[ ! -z "${VALUE}" ]]; then
			echo "${KEYWORD} = ${VALUE}"
			break
		elif [[ ${LATCH} -eq 0 ]]; then
			echo "${KEYWORD} = "
			break
		else
			break
		fi
	done
}

function parmtool_reader {
	local ROOTR="${1}"
	local ROOTE="${2}"
	local KEYWORD="${3}"
	local PATH0="${KEYWORD%\.\*}"
	local PATH1="${PATH0//\.//}"
	local PATHR="${ROOTR}/${PATH1}"
	local FILER="${PATHR}/.value"
	local PATHE="${ROOTE}/${PATH1}"
	local FILEE="${PATHE}/.value"
	local TEMP0=""
	local TEMP1=""
	local PATH2=""
	local PATH3=""
	if [[ -f ${FILER} ]]; then
		parmtool_consumer ${KEYWORD} < ${FILER}
	elif [[ -f ${FILEE} ]]; then
		parmtool_consumer ${KEYWORD} < ${FILEE}
	elif [[ -d ${PATHR} || -d ${PATHE} ]]; then
		TEMP0=`mktemp /tmp/${FILE}.XXXXXXXX`
		if [[ -d ${ROOTR} ]]; then
			(
				cd ${ROOTR}
				if [[ -d ${PATH1} ]]; then
					find ${PATH1} -type f -name .value -print
				fi
			) >> ${TEMP0}
		fi
		if [[ -d ${ROOTE} ]]; then
			(
				cd ${ROOTE}
				if [[ -d ${PATH1} ]]; then
					find ${PATH1} -type f -name .value -print
				fi
			) >> ${TEMP0}
		fi
		TEMP1=`mktemp /tmp/${FILE}.XXXXXXXX`
		sort < ${TEMP0} | uniq > ${TEMP1}
		rm -f ${TEMP0}
		while read PATH2; do
			PATH3="${PATH2%/.value}"
			PATHR="${ROOTR}/${PATH3}"
			FILER="${PATHR}/.value"
			PATHE="${ROOTE}/${PATH3}"
			FILEE="${PATHE}/.value"
			KEYWORD="${PATH3//\//.}"
			if [[ -f ${FILER} ]]; then
				parmtool_consumer ${KEYWORD} < ${FILER}
			elif [[ -f ${FILEE} ]]; then
				parmtool_consumer ${KEYWORD} < ${FILEE}
			else
				:
			fi
		done < ${TEMP1}
		rm -f ${TEMP1}
	else
		echo "${KEYWORD} = "
	fi
}

function parmtool_writer {
	local ROOT="${1}"
	local KEYWORD="${2}"
	local VALUE="${3}"
	local PATH0="${KEYWORD//\.//}"
	local PATH1="${ROOT}/${PATH0}"
	local FILE="${PATH1}/.value"
	mkdir -p ${PATH1}
	local TEMP=`mktemp ${FILE}.XXXXXXXX`
	echo -n "${VALUE}" > ${TEMP}
	if [[ -n "${MODE}" ]]; then
		chmod ${MODE} ${TEMP}
	fi
	mv -f ${TEMP} ${FILE}
}

function parmtool_deleter {
	local ROOTR="${1}"
	local ROOTE="${2}"
	local KEYWORD="${3}"
	local PATH0="${KEYWORD%\.\*}"
	local PATH1="${PATH0//\.//}"
	local PATHR="${ROOTR}/${PATH1}"
	local FILER="${PATHR}/.value"
	local PATHE="${ROOTE}/${PATH1}"
	local FILEE="${PATHE}/.value"
	if [[ -f ${FILER} ]]; then
		rm -f ${FILER}
	elif [[ -d ${PATHR} ]]; then
		rm -rf ${PATHR}
	elif [[ -f ${FILEE} ]]; then
		rm -f ${FILEE}
	elif [[ -d ${PATHE} ]]; then
		rm -rf ${PATHE}
	else
		:
	fi
}

function parmtool_lister {
	local ROOTR="${1}"
	local ROOTE="${2}"
	local KEYWORD=""
	local TEMP0=""
	local TEMP1=""
	local FILER=""
	local FILEE=""
	local PATH0=""
	if [[ -d ${ROOTR} || -d ${ROOTE} ]]; then
		TEMP0=`mktemp /tmp/${FILE}.XXXXXXXX`
		if [[ -d ${ROOTR} ]]; then
			( cd ${ROOTR}; find . -type f -name .value -print ) >> ${TEMP0}
		fi
		if [[ -d ${ROOTE} ]]; then
			( cd ${ROOTE}; find . -type f -name .value -print ) >> ${TEMP0}
		fi
		TEMP1=`mktemp /tmp/${FILE}.XXXXXXXX`
		sort < ${TEMP0} | uniq | sed 's/^\.\///' > ${TEMP1}
		rm -f ${TEMP0}
		while read PATH1; do
			FILER="${ROOTR}/${PATH1}"
			FILEE="${ROOTE}/${PATH1}"
			PATH0="${PATH1%/.value}"
			KEYWORD="${PATH0//\//.}"
			if [[ -f ${FILER} ]]; then
				parmtool_consumer ${KEYWORD} < ${FILER}
			elif [[ -f ${FILEE} ]]; then
				parmtool_consumer ${KEYWORD} < ${FILEE}
			else
				:
			fi
		done < ${TEMP1}
		rm -f ${TEMP1}
	else
		:
	fi
}

function parmtool_finder {
	local ROOTR="${1}"
	local ROOTE="${2}"
	if [[ -d ${ROOTE} ]]; then
		find ${ROOTE} -type f -print
	fi
	if [[ -d ${ROOTR} ]]; then
		find ${ROOTR} -type f -print
	fi
}

function parmtool_applier {
	local ROOTR="${1}"
	local ROOTE="${2}"
	local COMMAND="${3}"
	if [[ -d ${ROOTE} ]]; then
		find ${ROOTE} -type f -name .value -print -exec ${COMMAND} {} \;
	fi
	if [[ -d ${ROOTR} ]]; then
		find ${ROOTR} -type f -name .value -print -exec ${COMMAND} {} \;
	fi
}

function parmtool_updater {
	local ROOTR="${1}"
	local ROOTE="${2}"
	local ROOT="${3}"
	local KEYWORD="${4}"
	local VALUE="${5}"
	local BUFFER=$(parmtool_reader ${ROOTR} ${ROOTE} ${KEYWORD})
	if [[ "${BUFFER#*= }" != "${VALUE}" ]]; then
		parmtool_writer ${ROOT} ${KEYWORD} ${VALUE}
		RC=0
	else
		RC=2
	fi
}

while getopts "hA:aCcLld:r:m:w:u:U:W:" OPT; do

	case ${OPT} in

	h)
		echo "usage: ${ZERO} [ -L | -l | -a | -A COMMAND | -r KEYWORD | -d KEYWORD | [ -m MODE [ -w KEYWORD=VALUE | -W KEYWORD=VALUE | -u KEYWORD=VALUE | -U KEYWORD=VALUE ] | -C | -c ]" 1>&2
		;;

	a)
		parmtool_applier ${ROOTRUN} ${ROOTETC} "${CAT}"
		;;

	A)
		COMMAND="${OPTARG}"
		parmtool_applier ${ROOTRUN} ${ROOTETC} "${COMMAND}"
		;;

	C)
		rm -rf ${ROOTETC}
		;;

	c)
		rm -rf ${ROOTRUN}
		;;

	L)
		parmtool_finder ${ROOTRUN} ${ROOTETC}
		;;

	l)
		parmtool_lister ${ROOTRUN} ${ROOTETC}
		;;

	m)
		MODE="${OPTARG}"
		;;

	d)
		KEYWORD="${OPTARG%%=*}"
		parmtool_deleter ${ROOTRUN} ${ROOTETC} ${KEYWORD}
		;;

	r)
		KEYWORD="${OPTARG%%=*}"
		parmtool_reader ${ROOTRUN} ${ROOTETC} ${KEYWORD}
		;;
	u)
		KEYWORD="${OPTARG%%=*}"
		VALUE="${OPTARG#*=}"
		parmtool_updater ${ROOTRUN} ${ROOTETC} ${ROOTRUN} ${KEYWORD} ${VALUE}
		;;
	U)
		KEYWORD="${OPTARG%%=*}"
		VALUE="${OPTARG#*=}"
		parmtool_updater ${ROOTRUN} ${ROOTETC} ${ROOTETC} ${KEYWORD} ${VALUE}
		;;
	w)
		KEYWORD="${OPTARG%%=*}"
		VALUE="${OPTARG#*=}"
		parmtool_writer ${ROOTRUN} ${KEYWORD} ${VALUE}
		;;
	W)
		KEYWORD="${OPTARG%%=*}"
		VALUE="${OPTARG#*=}"
		parmtool_writer ${ROOTETC} ${KEYWORD} ${VALUE}
		;;

	esac

done

exit ${RC}
