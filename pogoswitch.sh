#!/bin/bash
# vi: set ts=4:
# Copyright 2015 Digital Aggregates Corporation, Colorado USA.
# Licensed under the terms of the GPLv2.

POWER_SERIALPORT="/dev/ttyUSB0"
POWER_BAUDRATE="9600"
POWER_LOGIN="admin"
POWER_PASSWD="admin"
POWER_OUTLET="1"
POWER_TIMEOUT="1"

TARGET_IPADDRESS="192.168.1.115"
TARGET_LOGIN="pi"
TARGET_PASSWD="raspberry"

OFFTIME="30"
ONTIME="120"
ITERATIONS="10"

RC=0
ZERO=`basename ${0}`
EXPECTFILE=`mktemp /tmp/${ZERO}.XXXXXXXX`
trap "rm -f ${EXPECTFILE}" HUP INT TERM

cat <<- EOF > ${EXPECTFILE}
stty ospeed ${POWER_BAUDRATE} ispeed ${POWER_BAUDRATE} cs8 < ${POWER_SERIALPORT}
set timeout ${POWER_TIMEOUT}
spawn -open [open ${POWER_SERIALPORT} RDWR]
send "\r"
expect { "\r>" { } timeout { exit 2 } }
send "login\r"
expect { "login\rUser ID: " { } timeout { exit 2 } }
send "${POWER_LOGIN}\r"
expect { "${POWER_LOGIN}\rPassword:" { } timeout { exit 2 } }
send "${POWER_PASSWD}\r"
expect { "*****\r>" { } timeout { exit 2 } }
send "pset ${POWER_OUTLET} 1\r"
expect { "pset ${POWER_OUTLET} 1\r>" { } timeout { exit 2 } }
EOF

expect -f ${EXPECTFILE} || exit 2

sleep ${ONTIME}
    
cat <<- EOF > ${EXPECTFILE}
set timeout ${TARGET_TIMEOUT}
spawn ssh ${TARGET_LOGIN}@${TARGET_IPADDRESS}
expect { "${TARGET_LOGIN}@${TARGET_IPADDRESS}'s password:" { } timeout { exit 2 } }
send "${TARGET_PASSWD}\r"
expect { "pi@raspberrypi ~ $ " { } timeout { exit 2 } }
send "exit \r"
expect { "logout\rConnection to ${TARGET_IPADDRESS} closed.\r" { } timeout { exit 2 } }
EOF
    
expect -f ${EXPECTFILE} || exit 2

while [ ${ITERATIONS} -gt 0 ]; do

	cat <<- EOF > ${EXPECTFILE}
	stty ospeed ${POWER_BAUDRATE} ispeed ${POWER_BAUDRATE} cs8 < ${POWER_SERIALPORT}
	set timeout ${POWER_TIMEOUT}
	spawn -open [open ${POWER_SERIALPORT} RDWR]
	send "\r"
	expect { "\r>" { } timeout { exit 2 } }
	send "pset ${POWER_OUTLET} 0\r"
	expect { "pset ${POWER_OUTLET} 0\r>" { } timeout { exit 2 } }
	EOF

	expect -f ${EXPECTFILE} || exit 2

	sleep ${OFFTIME}

	cat <<- EOF > ${EXPECTFILE}
	stty ospeed ${POWER_BAUDRATE} ispeed ${POWER_BAUDRATE} cs8 < ${POWER_SERIALPORT}
	set timeout ${POWER_TIMEOUT}
	spawn -open [open ${POWER_SERIALPORT} RDWR]
	send "\r"
	expect { "\r>" { } timeout { exit 2 } }
	send "pset ${POWER_OUTLET} 1\r"
	expect { "pset ${POWER_OUTLET} 1\r>" { } timeout { exit 2 } }
	EOF

	expect -f ${EXPECTFILE} || exit 2

	sleep ${ONTIME}
	
	cat <<- EOF > ${EXPECTFILE}
	set timeout ${TARGET_TIMEOUT}
	spawn ssh ${TARGET_LOGIN}@${TARGET_IPADDRESS}
	expect { "${TARGET_LOGIN}@${TARGET_IPADDRESS}'s password:" { } timeout { exit 2 } }
	send "${TARGET_PASSWD}\r"
	expect { "pi@raspberrypi ~ $ " { } timeout { exit 2 } }
	send "exit \r"
	expect { "logout\rConnection to ${TARGET_IPADDRESS} closed.\r" { } timeout { exit 2 } }
	EOF
	
	expect -f ${EXPECTFILE} || exit 2

	ITERATIONS=`expr ${ITERATIONS} - 1`

done

cat <<- EOF > ${EXPECTFILE}
stty ospeed ${POWER_BAUDRATE} ispeed ${POWER_BAUDRATE} cs8 < ${POWER_SERIALPORT}
set timeout ${POWER_TIMEOUT}
spawn -open [open ${POWER_SERIALPORT} RDWR]
send "\r"
expect { "\r>" { } timeout { exit 2 } }
send "logout\r"
expect { "logout\r>" { } timeout { exit 2 } }
EOF

expect -f ${EXPECTFILE} || exit 2

rm -f ${EXPECTFILE}
exit ${RC}
