#!/bin/bash
# vi: set ts=4:
# Copyright 2015 Digital Aggregates Corporation.
# Licensed under the terms of the GPLv2.

ZERO=`basename $0`

ROOTETC=${PARMTOOLETC:-"${HOME}/.parmtool/db"}
ROOTRUN=${PARMTOOLRUN:-"/tmp/${LOGNAME}/parmtool/db"}
CAT=${PARMTOOLCAT:-"cat"}

while getopts "hLld:r:w:W:X" OPT; do

	case ${OPT} in

	h)
		echo "${ZERO} [ -L | -l | -X | -r KEYWORD | -d KEYWORD | -w KEYWORD=VALUE | -W KEYWORD=VALUE ]" 1>&2
		;;

	L)
		if [ -d ${ROOTETC} ]; then
			find ${ROOTETC} -type f -print
		fi
		if [ -d ${ROOTRUN} ]; then
			find ${ROOTRUN} -type f -print
		fi
		;;

	l)
		ROOTR="${ROOTRUN}"
		ROOTE="${ROOTETC}"
		if [ -d ${FILER} -o -d ${FILEE} ]; then
			TEMP0=`mktemp /tmp/${FILE}.XXXXXXXX`
			if [ -d ${ROOTR} ]; then
				( cd ${ROOTR}; find . -type f -print ) >> ${TEMP0}
			fi
			if [ -d ${ROOTE} ]; then
				( cd ${ROOTE}; find . -type f -print ) >> ${TEMP0}
			fi
			TEMP1=`mktemp /tmp/${FILE}.XXXXXXXX`
			sort < ${TEMP0} | uniq | sed 's/^\.\///' > ${TEMP1}
			rm -f ${TEMP0}
			while read PATH1; do
				FILER="${ROOTR}/${PATH1}"
				FILEE="${ROOTE}/${PATH1}"
				KEYWORD="${PATH1//\//.}"
				if [ -f ${FILER} ]; then
					FILE="${FILER}"
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILE}
				elif [ -f ${FILEE} ]; then
					FILE="${FILEE}"
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILE}
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
		KEYWORD=`echo "${OPTARG}" | awk -F '=' '{ print $1; }'`
		PATHR="${KEYWORD//\.//}"
		FILER="${ROOTRUN}/${PATHR}"
		PATHE="${KEYWORD//\.//}"
		FILEE="${ROOTETC}/${PATHE}"
		if [ -f ${FILER} ]; then
			rm -f ${FILER}
		elif [ -d ${FILER} ]; then
			rm -rf ${FILER}
		elif [ -f ${FILEE} ]; then
			rm -f ${FILEE}
		elif [ -d ${FILEE} ]; then
			rm -rf ${FILEE}
		else
			:
		fi
		;;

	r)
		KEYWORD=`echo "${OPTARG}" | awk -F '=' '{ print $1; }'`
		PRE="${KEYWORD%\.\*}"
		PATH0="${PRE//\.//}"
		ROOTR="${ROOTRUN}"
		FILER="${ROOTR}/${PATH0}"
		ROOTE="${ROOTETC}"
		FILEE="${ROOTE}/${PATH0}"
		if [ -f ${FILER} ]; then
			FILE="${FILER}"
			while read VALUE; do
				echo ${KEYWORD} = ${VALUE}
			done < ${FILE}
		elif [ -f ${FILEE} ]; then
			FILE="${FILEE}"
			while read VALUE; do
				echo ${KEYWORD} = ${VALUE}
			done < ${FILE}
		elif [ -d ${FILER} -o -d ${FILEE} ]; then
			TEMP0=`mktemp /tmp/${FILE}.XXXXXXXX`
			if [ -d ${ROOTR} ]; then
				(
					cd ${ROOTR}
					if [ -d ${PATH0} ]; then
						find ${PATH0} -type f -print
					fi
				) >> ${TEMP0}
			fi
			if [ -d ${ROOTE} ]; then
				(
					cd ${ROOTE}
					if [ -d ${PATH0} ]; then
						find ${PATH0} -type f -print
					fi
				) >> ${TEMP0}
			fi
			TEMP1=`mktemp /tmp/${FILE}.XXXXXXXX`
			sort < ${TEMP0} | uniq > ${TEMP1}
			rm -f ${TEMP0}
			while read PATH1; do
				FILER="${ROOTR}/${PATH1}"
				FILEE="${ROOTE}/${PATH1}"
				KEYWORD="${PATH1//\//.}"
				if [ -f ${FILER} ]; then
					FILE="${FILER}"
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILE}
				elif [ -f ${FILEE} ]; then
					FILE="${FILEE}"
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILE}
				else
					:
				fi
			done < ${TEMP1}
			rm -f ${TEMP1}
		else
			:
		fi
		;;
	w)
		KEYWORD=`echo "${OPTARG}" | awk -F '=' '{ print $1; }'`
		VALUE=`echo "${OPTARG}" | awk -F '=' '{ print $2; }'`
		PATHR="${KEYWORD//\.//}"
		FILER="${ROOTRUN}/${PATHR}"
		ROOTR=`dirname ${FILER}`
		if [ ! -d ${ROOTR} ]; then
			 mkdir -p ${ROOTR}
		fi
		TEMPR=`mktemp ${FILER}.XXXXXXXX`
		echo "${VALUE}" > ${TEMPR}
		mv -f ${TEMPR} ${FILER}
		;;
	W)
		KEYWORD=`echo "${OPTARG}" | awk -F '=' '{ print $1; }'`
		VALUE=`echo "${OPTARG}" | awk -F '=' '{ print $2; }'`
		PATHE="${KEYWORD//\.//}"
		FILEE="${ROOTETC}/${PATHE}"
		ROOTE=`dirname ${FILEE}`
		if [ ! -d ${ROOTE} ]; then
			mkdir -p ${ROOTE}
		fi
		TEMPE=`mktemp ${FILEE}.XXXXXXXX`
		echo "${VALUE}" > ${TEMPE}
		mv -f ${TEMPE} ${FILEE}
		;;

	X)
		if [ -d ${ROOTETC} ]; then
			find ${ROOTETC} -type f -print -exec ${CAT} {} \;
		fi
		if [ -d ${ROOTRUN} ]; then
			find ${ROOTRUN} -type f -print -exec ${CAT} {} \;
		fi
		;;

	esac

done

exit 0
