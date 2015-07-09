#!/bin/bash
# vi: set ts=4:
# Copyright 2015 Digital Aggregates Corporation, Colorado USA.
# Licensed under the terms of the GPLv2.

SERIALPORT="/dev/ttyUSB0"
BAUDRATE="9600"
TIMEOUT="1"
ITERATIONS="10"
LOGIN="admin"
PASSWD="admin"
OUTLET="1"
OFFTIME="20"
ONTIME="90"

RC=0
ZERO=`basename ${0}`
EXPECTFILE=`mktemp /tmp/${ZERO}.XXXXXXXX`
trap "rm -f ${EXPECTFILE}" ERR HUP INT TERM

cat <<- EOF > ${EXPECTFILE}
stty ospeed ${BAUDRATE} ispeed ${BAUDRATE} cs8 < ${SERIALPORT}
set timeout ${TIMEOUT}
spawn -open [open ${SERIALPORT} RDWR]
send "\r"
expect { "\r>" { } timeout { abort } }
send "login\r"
expect { "login\rUser ID: " { } timeout { abort } }
send "${LOGIN}\r"
expect { "${LOGIN}\rPassword:" { } timeout { abort } }
send "${PASSWD}\r"
expect { "*****\r>" { } timeout { abort } }
send "pset ${OUTLET} 1\r"
expect { "pset ${OUTPUT} 1\r>" { } timeout { abort } }
EOF

expect -f ${EXPECTFILE} || exit 2

sleep ${ONTIME}

while [ ${ITERATIONS} -gt 0 ]; do

	cat <<- EOF > ${EXPECTFILE}
	stty ospeed ${BAUDRATE} ispeed ${BAUDRATE} cs8 < ${SERIALPORT}
	set timeout ${TIMEOUT}
	spawn -open [open ${SERIALPORT} RDWR]
	send "\r"
	expect { "\r>" { } timeout { abort } }
	send "pset ${OUTLET} 0\r"
	expect { "pset ${OUTPUT} 0\r>" { } timeout { abort } }
	EOF

	expect -f ${EXPECTFILE} || exit 2

	sleep ${OFFTIME}

	cat <<- EOF > ${EXPECTFILE}
	stty ospeed ${BAUDRATE} ispeed ${BAUDRATE} cs8 < ${SERIALPORT}
	set timeout ${TIMEOUT}
	spawn -open [open ${SERIALPORT} RDWR]
	send "\r"
	expect { "\r>" { } timeout { abort } }
	send "pset ${OUTLET} 1\r"
	expect { "pset ${OUTPUT} 1\r>" { } timeout { abort } }
	EOF

	expect -f ${EXPECTFILE} || exit 2

	sleep ${ONTIME}

	ITERATIONS=`expr ${ITERATIONS} - 1`

done

cat <<- EOF > ${EXPECTFILE}
stty ospeed ${BAUDRATE} ispeed ${BAUDRATE} cs8 < ${SERIALPORT}
set timeout ${TIMEOUT}
spawn -open [open ${SERIALPORT} RDWR]
send "\r"
expect { "\r>" { } timeout { abort } }
send "logout\r"
expect { "logout\r>" { } timeout { abort } }
EOF

expect -f ${EXPECTFILE} || exit 2

rm -f ${EXPECTFILE}
exit ${RC}
