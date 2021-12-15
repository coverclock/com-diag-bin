#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
# USAGE dkimgenerate.sh DOMAIN [ SELECTOR ]
# EXAMPLE dkmgenerate.sh diag.com
# WORK IN PROGRESS!
# Tested but not used yet in production.
# Based on an actual example provided by the ISP indra.com.
# File generated:
#    <SELECTOR>.txt	- data to be placed in DNS TXT RR.
#    <SELECTOR>.txt-N   - data file split into 255 octet TXT-friendly chunks.
#    <SELECTOR>.key     - private key.
#    <SELECTOR>.nam     - name of DNS TXT RR.
#    dkimgenerate.log   - standard error log.

PGM=$(basename $0 .sh)
LOG="${PGM}.log"
cp /dev/null ${LOG}
exec 2>> ${LOG}

DOM=${1}
test -z "${DOM}" && exit 1

SEL=${2:-$(uuidgen -t | tr '[a-z]' '[A-Z]')}

KEY="${SEL}.key"
TXT="${SEL}.txt"
NAM="${SEL}.nam"

openssl genrsa -out ${KEY} 2048
PUB=$(openssl rsa -in ${KEY} -pubout -outform der | openssl base64 -A)

echo "v=DKIM1; k=rsa; p=${PUB}" > ${TXT}
split -a 1 -b 255 -d ${TXT} ${TXT}-

echo "${SEL}._domainkey.${DOM}" > ${NAM}
cat ${NAM}

exit 0
