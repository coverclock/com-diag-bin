#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
# USAGE dkimgenerate.sh DOMAIN MAILSERVICE [ KEYLENGTH ]
# EXAMPLE dkmgenerate.sh diag.com indra 2048
# WORK IN PROGRESS!

DOM=${1}
SER=${2}
test -z "${DOM}" && exit 1
test -z "${SER}" && exit 1
LEN=${3:-"2048"}

YMD=$(date -u +\%Y\%m\%d)
NAM="${SER}${YMD}"

LOG="${NAM}.log"
KEY="${NAM}.key"
DNS="${NAM}.dns"
REC="${NAM}.rec"

cp /dev/null ${LOG}
exec 2>> ${LOG}

openssl genrsa -out ${KEY} ${LEN}

PUB=$(openssl rsa -in ${KEY} -pubout -outform der | openssl base64 -A)

TXT="v=DKIM1;"
TXT+=" k=rsa;"
TXT+=" s=${NAM};"
TXT+=" p=${PUB}"
echo "${TXT}" > ${DNS}
split -a 1 -b 255 -d ${DNS} ${DNS}-

echo "${NAM}._domainkey.${DOM}" > ${REC}
cat ${REC}
