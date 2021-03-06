#!/bin/bash
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

LST=".cscope.lst"
REF=".cscope.out"
INF=".cscope.out.in"
POF=".cscope.out.po"

if [ ! \( -f ${INF} -a -f ${POF} \) ]; then

	if [ $# -eq 0 ]; then
		DIR="."
	else
		DIR="$*"
	fi

	rm -f .cscope.*

	cp /dev/null ${LST}

	(
		for DD in ${DIR}; do
			find -P ${DD} \
				-type d -name .svn -prune -o \
				-type d -name .git -prune -o \
				-type d -path ./.repo -prune -o \
				-type d -path ./out -prune -o \
				-type f -a \( \
					-name '*.[CcHhSs]' -o \
					-name '*.[a-z]mk' -o \
					-name '*.cc' -o \
					-name '*.cpp' -o \
					-name '*.cxx' -o \
					-name '*.dts' -o \
					-name '*.hpp' -o \
					-name '*.hx' -o \
					-name '*.hxx' -o \
					-name '*.inl' -o \
					-name '*.ld' -o \
					-name '*.map' -o \
					-name '*.mk' -o \
					-name '*.rc' -o \
					-name '*.sh' -o \
					-name '*.txt' -o \
					-name '*.xml' -o \
					-name '*.xsd' -o \
					-name '*_defconfig' -o \
					-name '.config' -o \
					-name 'Config.in*' -o \
					-name 'GNUmakefile*' -o \
					-name 'Kconfig*' -o \
					-name '[Mm]akefile*' -o \
					-name 'configure' -o \
					-name '*.conf' -o \
					-name '*.inc' -o \
					-name '*.java' -o \
					-name '*.x' -o \
					-name '*.x[nru]' -o \
					-name '*.xbn' -o \
					-false \
				\) -print
		done
	) | sed 's/^/"/;s/$/"/' | sort | uniq > ${LST}

fi

exec cscope -kqR -i${LST} -f${REF}
