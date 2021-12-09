#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
CERT=${1}
openssl x509 -in ${CERT} -text
