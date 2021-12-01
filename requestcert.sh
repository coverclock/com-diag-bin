#!/bin/bash
NAME=${1:-$(hostname)}
TYPE=${2:-"rsa:2048"}
DAYS=${3:-365}
sudo openssl req -nodes -days ${DAYS} -newkey ${TYPE} -keyout ${NAME}.key -out ${NAME}.csr
# KEY goes in /etc/ssl/private.
# CSR goes in /etc/ssl/certs.
