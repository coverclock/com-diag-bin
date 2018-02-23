#/bin/bash
# vi: set ts=4:
# Copyright 2018 Digital Aggregates Corporation.
# Licensed under the terms in LICENSE.txt.
# ABSTRACT
# Generate a self-signed manifest containing the checksums
# of the files in the specified payload.
# EXIT
#	Returns with exit 0 if successful, >0 otherwise.
# INPUTS
#	PRIVATEKEY.pem
#	CERTIFICATE.crt
#	FILE [ FILE ... ]
# OUTPUTS
#	MANIFEST.dat

ZERO=$(basename $0 .sh)

PRIVATEKEY="./codex.pem"
MANIFEST="./codex.dat"
CERTIFICATE="./codex.crt"

while getopts "hk:o:s:" OPT; do
	case ${OPT} in
	h)
		echo "usage: ${ZERO} [ -k PRIVATEKEY.pem ] [ -o MANIFEST.dat ] [ -s CERTIFICATE.crt ] -- FILE [ FILE ... ]" 1>&2
		exit 0
		;;
	k)
		PRIVATEKEY="${OPTARG}"
		;;
	o)
		MANIFEST="${OPTARG}"
		;;
	s)
		CERTIFICATE="${OPTARG}"
		;;
	esac
done

shift $((OPTIND - 1))

sha1sum "${@}" | eval openssl smime -nocerts -sign -inkey ${PRIVATEKEY} -signer ${CERTIFICATE} -out ${MANIFEST} || exit 2

exit 0
