#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
# USAGE dkimgenerate.sh DOMAIN MAILSERVICE USER
# EXAMPLE dkmgenerate.sh diag.com indra coverclock
DOM=${1}
SER=${2}
test -z "${DOM}" && exit 1
test =z "${SER}" && exit 1
USR=${3:-"${USER}"}
YMD=$(date -u +\%Y\%m\%d)
SEL="${SER}${YMD}"
NAM="${SEL}._domainkey.${DOM}"
KEY="${SEL}.key"
openssl genrsa -out ${KEY} 2048
PUB=$(openssl rsa -in ${KEY} -pubout -outform der 2>/dev/null | openssl base64 -A)
TXT="v=DKIM1;"
TXT+=" k=rsa;"
TXT+=" s=${SEL};"
TXT+=" p=${PUB}"
DNS="${SEL}.dns"
echo "${TXT}" > ${DNS}
split -b 255 ${DNS} ${DNS}-
echo "${NAM}"
