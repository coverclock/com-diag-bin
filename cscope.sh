:
# vim: ts=4
# Copyright 2014 Digital Aggregates Corp.

LST=.cscope.lst
REF=.cscope.out
INF=.cscope.out.in
POF=.cscope.out.po

if [ -f ${INF} -a -f ${POF} ]; then
	exec cscope -qR -i${LST} -f${REF}
fi

rm -f .cscope.*
cp /dev/null ${LST}

if [ $# -eq 0 ]; then
	DIR="."
else
	DIR="$*"
fi

INC="`${CROSS_COMPILE}gcc -xc -E -v - < /dev/null 2>&1 | grep '^[ ]' | sed 's/^ //' | grep -v ' '`"

(
	cd ${DIR}
	for II in ${INC}; do
		find -P ${II} -type f -print
	done
	for DD in .; do
		find -P ${DD} \
			-type d -name .svn -prune -o \
			-type d -name .git -prune -o \
			-type d -name .repo -prune -o \
			-type d -path ./out -prune -o \
			-type d -path ./prebuilts -prune -o \
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
				-name '*.xml' -o \
				-name '*.xsd' \
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
) | sed 's/^/"/;s/$/"/' > ${LST}

exec cscope -qR -i${LST} -f${REF}

