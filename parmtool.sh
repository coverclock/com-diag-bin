#!/bin/bash
# vi: set ts=4:
# Copyright 2015 Digital Aggregates Corporation.
# Licensed under the terms of the GPLv2.

ZERO=`basename $0`

ROOTETC=${PARMTOOLETC:-"${HOME}/.parmtool/db"}
ROOTRUN=${PARMTOOLRUN:-"/tmp/${LOGNAME}/parmtool/db"}
CAT=${PARMTOOLCAT:-"cat"}

while getopts "hLlcd:r:w:CW:X" OPT; do

	case ${OPT} in

	h)
		echo "${ZERO} [ -L | -l | -X | -r KEYWORD | -d KEYWORD | -w KEYWORD=VALUE | -W KEYWORD=VALUE ]" 1>&2
		;;

	C)
		rm -rf ${ROOTETC}
		;;

	c)
		rm -rf ${ROOTRUN}
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
		KEYWORD="${OPTARG%%=*}"
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
		KEYWORD="${OPTARG%%=*}"
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
						find ${PATH1} -type f -name .value -print
					fi
				) >> ${TEMP0}
			fi
			if [ -d ${ROOTE} ]; then
				(
					cd ${ROOTE}
					if [ -d ${PATH1} ]; then
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
		KEYWORD="${OPTARG%%=*}"
		VALUE="${OPTARG##*=}"
		PATH0="${KEYWORD//\.//}"
		PATHR="${ROOTRUN}/${PATH0}"
		FILER="${PATHR}/.value"
		if [ ! -d ${PATHR} ]; then
			 mkdir -p ${PATHR}
		fi
		TEMPR=`mktemp ${FILER}.XXXXXXXX`
		echo "${VALUE}" > ${TEMPR}
		mv -f ${TEMPR} ${FILER}
		;;
	W)
		KEYWORD="${OPTARG%%=*}"
		VALUE="${OPTARG##*=}"
		PATH0="${KEYWORD//\.//}"
		PATHE="${ROOTETC}/${PATH0}"
		FILEE="${PATHE}/.value"
		if [ ! -d ${PATHE} ]; then
			mkdir -p ${PATHE}
		fi
		TEMPE=`mktemp ${FILEE}.XXXXXXXX`
		echo "${VALUE}" > ${TEMPE}
		mv -f ${TEMPE} ${FILEE}
		;;

	X)
		if [ -d ${ROOTETC} ]; then
			find ${ROOTETC} -type f -name .value -print -exec ${CAT} {} \;
		fi
		if [ -d ${ROOTRUN} ]; then
			find ${ROOTRUN} -type f -name .value -print -exec ${CAT} {} \;
		fi
		;;

	esac

done

exit 0
