#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
# USAGE dkimgenerate.sh DOMAIN
# EXAMPLE dkmgenerate.sh diag.com
# WORK IN PROGRESS!
# File generated:
#    <UUID>.dns   - data to be placed in DNS TXT RR.
#    <UUID>.dns-N - DNS file split into 255 octet chunks.
#    <UUID>.key   - private key.
#    <UUID>.log   - standard error log.
#    <UUID>.rec   - name of DNS TXT RR.

DOM=${1}

UUID=$(uuidgen -t)
test -z "${DOM}" && exit 1

LOG="${UUID}.log"
KEY="${UUID}.key"
DNS="${UUID}.dns"
REC="${UUID}.rec"

cp /dev/null ${LOG}
exec 2>> ${LOG}

openssl genrsa -out ${KEY} 2048

PUB=$(openssl rsa -in ${KEY} -pubout -outform der | openssl base64 -A)

TXT="v=DKIM1;"
TXT+=" k=rsa;"
TXT+=" s=${UUID};"
TXT+=" p=${PUB}"
echo "${TXT}" > ${DNS}
split -a 1 -b 255 -d ${DNS} ${DNS}-

echo "${UUID}._domainkey.${DOM}" > ${REC}
cat ${REC}
