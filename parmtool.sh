#!/bin/bash
# vi: set ts=4:
# Copyright 2015 Digital Aggregates Corporation.
# Licensed under the terms of the GPLv2.

ZERO=`basename $0`

ROOTETC=${PARMTOOLETC:-"${HOME}/.parmtool/db"}
ROOTRUN=${PARMTOOLRUN:-"/tmp/${LOGNAME}/parmtool/db"}
CAT=${PARMTOOLCAT:-"cat"}

while getopts "hLlr:w:W:" OPT; do

	case ${OPT} in

	h)
		echo "${ZERO} [ -L | -l | -r KEYWORD | -w KEYWORD=VALUE | -W KEYWORD=VALUE ]" 1>&2
		;;

	L)
		test -d ${ROOTETC} && find ${ROOTETC} -type f -print -exec ${CAT} {} \;
		test -d ${ROOTRUN} && find ${ROOTRUN} -type f -print -exec ${CAT} {} \;
		;;

	l)
		ROOTR="${ROOTRUN}"
		ROOTE="${ROOTETC}"
		if [ -d ${FILER} -o -d ${FILEE} ]; then
			TEMP0=`mktemp /tmp/${FILE}.XXXXXXXX`
			test -d ${ROOTR} && ( cd ${ROOTR}; find . -type f -print ) >> ${TEMP0}
			test -d ${ROOTE} && ( cd ${ROOTE}; find . -type f -print ) >> ${TEMP0}
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
			test -d ${ROOTR} && ( cd ${ROOTR}; test -d ${PATH0} && find ${PATH0} -type f -print ) >> ${TEMP0}
			test -d ${ROOTE} && ( cd ${ROOTE}; test -d ${PATH0} && find ${PATH0} -type f -print ) >> ${TEMP0}
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
		test -d ${ROOTR} || mkdir -p ${ROOTR}
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
		test -d ${ROOTE} || mkdir -p ${ROOTE}
		TEMPE=`mktemp ${FILEE}.XXXXXXXX`
		echo "${VALUE}" > ${TEMPE}
		mv -f ${TEMPE} ${FILEE}
		;;

	esac

done

exit 0
