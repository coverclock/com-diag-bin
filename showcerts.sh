#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
FQDN=${1}
PORT=${2:-443}
openssl s_client -showcerts -connect ${FQDN}:443
