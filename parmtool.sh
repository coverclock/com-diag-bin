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
				( cd ${ROOTR}; find . -type f -name .value -print ) >> ${TEMP0}
			fi
			if [ -d ${ROOTE} ]; then
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
				if [ -f ${FILER} ]; then
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILER}
				elif [ -f ${FILEE} ]; then
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILEE}
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
		PATH0="${KEYWORD%\.\*}"
		PATH1="${PATH0//\.//}"
		PATHR="${ROOTRUN}/${PATH1}"
		FILER="${PATHR}/.value"
		PATHE="${ROOTETC}/${PATH1}"
		FILEE="${PATHE}/.value"
		if [ -f ${FILER} ]; then
			rm -f ${FILER}
		elif [ -d ${PATHR} ]; then
			rm -rf ${PATHR}
		elif [ -f ${FILEE} ]; then
			rm -f ${FILEE}
		elif [ -d ${PATHE} ]; then
			rm -rf ${PATHE}
		else
			:
		fi
		;;

	r)
		KEYWORD=`echo "${OPTARG}" | awk -F '=' '{ print $1; }'`
		PATH0="${KEYWORD%\.\*}"
		PATH1="${PATH0//\.//}"
		ROOTR="${ROOTRUN}"
		PATHR="${ROOTR}/${PATH1}"
		FILER="${PATHR}/.value"
		ROOTE="${ROOTETC}"
		PATHE="${ROOTE}/${PATH1}"
		FILEE="${PATHE}/.value"
		if [ -f ${FILER} ]; then
			while read VALUE; do
				echo ${KEYWORD} = ${VALUE}
			done < ${FILER}
		elif [ -f ${FILEE} ]; then
			while read VALUE; do
				echo ${KEYWORD} = ${VALUE}
			done < ${FILEE}
		elif [ -d ${PATHR} -o -d ${PATHE} ]; then
			TEMP0=`mktemp /tmp/${FILE}.XXXXXXXX`
			if [ -d ${ROOTR} ]; then
				(
					cd ${ROOTR}
					if [ -d ${PATH1} ]; then
						find ${PATH1} -type f -print
					fi
				) >> ${TEMP0}
			fi
			if [ -d ${ROOTE} ]; then
				(
					cd ${ROOTE}
					if [ -d ${PATH1} ]; then
						find ${PATH1} -type f -print
					fi
				) >> ${TEMP0}
			fi
			TEMP1=`mktemp /tmp/${FILE}.XXXXXXXX`
			sort < ${TEMP0} | uniq > ${TEMP1}
			rm -f ${TEMP0}
			while read PATH2; do
				PATHR="${ROOTR}/${PATH2}"
				FILER="${PATHR}/.value"
				PATHE="${ROOTE}/${PATH2}"
				FILEE="${PATHE}/.value"
				KEYWORD="${PATH2//\//.}"
				if [ -f ${FILER} ]; then
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILER}
				elif [ -f ${FILEE} ]; then
					while read VALUE; do
						echo ${KEYWORD} = ${VALUE}
					done < ${FILEE}
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
		PATH0="${KEYWORD//\.//}"
		FILER="${ROOTRUN}/${PATH0}"
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
		PATH0="${KEYWORD//\.//}"
		FILEE="${ROOTETC}/${PATH0}"
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
