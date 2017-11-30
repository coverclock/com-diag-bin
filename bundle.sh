#!/bin/bash -x

BASNAM=$(basename ${0})

CURDIR=$(pwd)
SRCDIR=${HOME}/src/gerrit/st4300
TMPDIR=${TMPDIR:-"/tmp"}
NEWDIR=$(mktemp -d ${TMPDIR}/${BASNAM}.XXXXXXXXXX)
SNKDIR=${NEWDIR}/archive

mkdir -p ${SNKDIR}/st4300-rm
mkdir -p ${SNKDIR}/st4300-ss
mkdir -p ${SNKDIR}/st4300-us

tar -C ${SRCDIR}/resource-manager/out -cvf - . | tar -C ${SNKDIR}/st4300-rm -xvf -
tar -C ${SRCDIR}/safety-services/out  -cvf - . | tar -C ${SNKDIR}/st4300-ss -xvf -
tar -C ${SRCDIR}/user-services/out    -cvf - . | tar -C ${SNKDIR}/st4300-us -xvf -

(
	cd ${SNKDIR}
	zip -r st4300-rm.zip st4300-rm
	zip -r st4300-ss.zip st4300-ss
	zip -r st4300-us.zip st4300-us
	zip -r ${CURDIR}/archive.zip st4300-rm.zip st4300-ss.zip st4300-us.zip
)

rm -r ${NEWDIR}
