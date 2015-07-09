#!/bin/bash
# vi: set ts=4:
# Copyright 2015 Digital Aggregates Corporation, Colorado USA.
# Licensed under the terms of the GPLv2.

RC=0
ZERO=`basename ${0}`
EXPECTFILE=`mktemp /tmp/${ZERO}.XXXXXXXX`
trap "rm -f ${EXPECTFILE}" ERR HUP INT TERM
BAUDRATE="9600"
SERIALPORT="/dev/ttyUSB0"
TIMEOUT="5"
REPEAT=10
NETBOOTERLOGIN="admin"
NETBOOTERPASSWD="admin"

cat << EOF > ${EXPECTFILE}
stty ospeed ${BAUDRATE} ispeed ${BAUDRATE} cs8 < ${SERIALPORT}
set timeout ${TIMEOUT}
spawn -open [open ${SERIALPORT} RDWR]
send "\r"
expect { "\r>" { } timeout { abort } }
send "login\r"
expect { "login\rUser ID: " { } timeout { abort } }
send "${NETBOOTERLOGIN}\r"
expect { "${NETBOOTERLOGIN}\rPassword:" { } timeout { abort } }
send "${NETBOOTERPASSWD}\r"
expect { "*****\r>" { } timeout { abort } }
send "logout\r"
expect { "logout\r>" { } timeout { abort } }
EOF

expect -f ${EXPECTFILE} || exit 2

rm -f ${EXPECTFILE}
exit ${RC}
