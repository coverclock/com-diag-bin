#/bin/bash
# vi: set ts=4:
# Copyright 2018 Digital Aggregates Corporation.
# Licensed under the terms in LICENSE.txt.
# ABSTRACT
# Generate the self-signed certificate and private key
# necessary for use with generating and verifying a
# manifest.
# EXIT
#	Returns with exit 0 if successful, >0 otherwise.
# INPUTS
#	CONFIGURATION.cnf (optional)
#	EXPIRATION (in days)
# OUTPUTS
#	PRIVATEKEY.pem
#	CERTIFICATE.crt

ZERO=$(basename $0 .sh)

CERTIFICATE="codex.crt"
CONFIGURATION=""
EXPIRATION="3653"
PRIVATEKEY="codex.pem"

while getopts "c:d:hk:o:" OPT; do
	case ${OPT} in
	c)
		CONFIGURATION="${OPTARG}"
		;;
	d)
		EXPIRATION="${OPTARG}"
		;;
	h)
		echo "usage: ${ZERO} [ -c CONFIGURATION.cnf ] [ -d EXPIRATION ] [ -k PRIVATEKEY.pem ] [ -o CERTIFICATE.crt ]" 1>&2
		exit 0
		;;
	k)
		PRIVATEKEY="${OPTARG}"
		;;
	o)
		CERTIFICATE="${OPTARG}"
		;;
	esac
done

shift $((OPTIND - 1))

if [[ -n "${CONFIGURATION}" ]]; then
	openssl req -x509 -newkey rsa:4096 -nodes -config ${CONFIGURATION} -keyout ${PRIVATEKEY} -out ${CERTIFICATE} -days ${EXPIRATION} || exit 2
else
	openssl req -x509 -newkey rsa:4096 -nodes -keyout ${PRIVATEKEY} -out ${CERTIFICATE} -days ${EXPIRATION} || exit 3
fi

exit 0
