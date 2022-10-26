#!/bin/bash
# Copyright 2022 Digital Aggregates Corporation, Colorado, USA
# Licensed under the terms in LICENSE.txt
# Chip Overclock <coverclock@diag.com>
# https://github.com/coverclock/com-diag-diminuto
#
# When run on the target, this script generates the platform descriptions I
# use in the project's README. Note that in the case of cross-compilation, there
# will be two platforms: the one on which the project is built, and the on
# which the project is run. See the platforms listed in the Diminuto README
# for additional examples.
#
# EXAMPLES
#
# $ platform
# Intel(R) Core(TM) i7-7567U CPU @ 3.50GHz
# x86_64 x4
# Ubuntu 20.04.3 LTS (Focal Fossa)
# Linux 5.13.0-28-generic
# gcc (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
# ldd (Ubuntu GLIBC 2.31-0ubuntu9.7) 2.31
# GNU Make 4.2.1
#

PROCESSORS=1
TARGET="unknown"
if [[ -r /proc/cpuinfo ]]; then
	PROCESSORS=$(grep '^processor[	]*: ' /proc/cpuinfo | wc -l)
	# Probably Intel.
	MODELNAME=$(grep '^model name[	]*: ' /proc/cpuinfo | head -1 | sed 's/^model name[	]*: //')
	MODEL=$(grep '^Model[	]*: ' /proc/cpuinfo | head -1 | sed 's/^Model[	]*: //')
	# Probably ARM.
	HARDWARE=$(grep '^Hardware[	]*: ' /proc/cpuinfo | head -1 | sed 's/^Hardware[	]*: //')
	REVISION=$(grep '^Revision[	]*: ' /proc/cpuinfo | head -1 | sed 's/^Revision[	]*: //')
	# Probably RISC-V.
	ISA=$(grep '^isa[	]*: ' /proc/cpuinfo | head -1 | sed 's/^isa[	]*: //')
	MMU=$(grep '^mmu[	]*: ' /proc/cpuinfo | head -1 | sed 's/^mmu[	]*: //')
	UARCH=$(grep '^uarch[	]*: ' /proc/cpuinfo | head -1 | sed 's/^uarch[	]*: //')
fi
TARGET=$(echo "${MODELNAME}" "${MODEL}" "${HARDWARE}" "${REVISION}" "${ISA}" "${MMU}" "${UARCH}")

if [[ -r /etc/os-release ]]; then
	. /etc/os-release
	OPERATINGSYSTEM="${NAME} ${VERSION}"
fi

PROCESSORTYPE=$(uname -m)
KERNELNAME=$(uname -s)
KERNELRELEASE=$(uname -r)

GCCVERSION=$(gcc --version | head -1)
LIBCVERSION=$(ldd --version | head -1)
MAKEVERSION=$(make --version | head -1)

echo ${TARGET}
echo ${PROCESSORTYPE} x${PROCESSORS}
echo ${OPERATINGSYSTEM}
echo ${KERNELNAME} ${KERNELRELEASE}
echo ${GCCVERSION}
echo ${LIBCVERSION}
echo ${MAKEVERSION}

exit 0
