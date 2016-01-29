#!/bin/bash
# vi: set ts=4:
# Copyright 2015 Digital Aggregates Corporation.
# Licensed under the terms of the GPLv2.
# WORK IN PROGRESS

ZERO=`basename $0`

ROOTETC=${PARMTOOLETC:-"${HOME}/.parmtool/db"}
ROOTRUN=${PARMTOOLRUN:-"/tmp/${LOGNAME}/parmtool/db"}
CAT=${PARMTOOLCAT:-"cat"}

function parmtool_reader {
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
	mv -f ${TEMP} ${FILE}
}

while getopts "hLlcd:n:r:w:CW:X" OPT; do

	case ${OPT} in

	h)
		echo "usage: ${ZERO} [ -L | -l | -X | -r KEYWORD | -d KEYWORD | -w KEYWORD=VALUE | -W KEYWORD=VALUE | -C | -c ]" 1>&2
		;;

	C)
		rm -rf ${ROOTETC}
		;;

	c)
		rm -rf ${ROOTRUN}
		;;

	L)
		ROOTR="${ROOTRUN}"
		ROOTE="${ROOTETC}"
		if [[ -d ${ROOTE} ]]; then
			find ${ROOTE} -type f -print
		fi
		if [[ -d ${ROOTR} ]]; then
			find ${ROOTR} -type f -print
		fi
		;;

	l)
		ROOTR="${ROOTRUN}"
		ROOTE="${ROOTETC}"
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
					parmtool_reader ${KEYWORD} < ${FILER}
				elif [[ -f ${FILEE} ]]; then
					parmtool_reader ${KEYWORD} < ${FILEE}
				else
					:
				fi
			done < ${TEMP1}
			rm -f ${TEMP1}
		else
			:
		fi
		;;

	d)
		KEYWORD="${OPTARG%%=*}"
		PATH0="${KEYWORD%\.\*}"
		PATH1="${PATH0//\.//}"
		PATHR="${ROOTRUN}/${PATH1}"
		FILER="${PATHR}/.value"
		PATHE="${ROOTETC}/${PATH1}"
		FILEE="${PATHE}/.value"
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
		;;

	r)
		KEYWORD="${OPTARG%%=*}"
		PATH0="${KEYWORD%\.\*}"
		PATH1="${PATH0//\.//}"
		ROOTR="${ROOTRUN}"
		PATHR="${ROOTR}/${PATH1}"
		FILER="${PATHR}/.value"
		ROOTE="${ROOTETC}"
		PATHE="${ROOTE}/${PATH1}"
		FILEE="${PATHE}/.value"
		if [[ -f ${FILER} ]]; then
			parmtool_reader ${KEYWORD} < ${FILER}
		elif [[ -f ${FILEE} ]]; then
			parmtool_reader ${KEYWORD} < ${FILEE}
			LATCH=0
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
					parmtool_reader ${KEYWORD} < ${FILER}
				elif [[ -f ${FILEE} ]]; then
					parmtool_reader ${KEYWORD} < ${FILEE}
				else
					:
				fi
			done < ${TEMP1}
			rm -f ${TEMP1}
		else
			echo "${KEYWORD} = "
		fi
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

	X)
		if [[ -d ${ROOTETC} ]]; then
			find ${ROOTETC} -type f -name .value -print -exec ${CAT} {} \;
		fi
		if [[ -d ${ROOTRUN} ]]; then
			find ${ROOTRUN} -type f -name .value -print -exec ${CAT} {} \;
		fi
		;;

	esac

done

exit 0
