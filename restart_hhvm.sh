#! /bin/bash

if [ "$1" == "" ]; then
	DEFAULT_HHVM_SERVICES=""
	while read fn; do
        	svcname="`basename $fn`"
        	if [[ "`rc-status | grep -e "^ $svcname\s"`" != "" ]]; then
                	DEFAULT_HHVM_SERVICES="`echo "$DEFAULT_HHVM_SERVICES"`$svcname "
        	fi
	done < <(find -L /etc/init.d/ -samefile /etc/init.d/hhvm)

	echo "Restarting $DEFAULT_HHVM_SERVICES"
	for svc in $DEFAULT_HHVM_SERVICES; do
		$0 $svc
	done
        exit 1
fi

SVCNAME=$1

if [[ "`find -L /etc/init.d/ -samefile /etc/init.d/hhvm | grep /etc/init.d/${SVCNAME}`" == "" ]]; then
	# Allow short parameter as hhvm.$1
	if [[ "`find -L /etc/init.d/ -samefile /etc/init.d/hhvm | grep /etc/init.d/hhvm.${SVCNAME}`" != "" ]]; then
		SVCNAME=hhvm.$SVCNAME
	else
		echo "FATAL: $SVCNAME is not a HHVM service!"
		exit 1
	fi
fi

TIMEOUT=${2:-10}
PID="`cat /var/run/hhvm/${SVCNAME}.pid`"

if [ "$PID" == "" ]; then
        echo No PID, starting up
        /etc/init.d/${SVCNAME} restart
else
        /etc/init.d/${SVCNAME} restart
        sleep $TIMEOUT
        NEWPID="`cat /var/run/hhvm/${SVCNAME}.pid`"
        if [ "$NEWPID" == "$PID" ]; then
                NEWPID=
        fi
        if ! kill -0 $NEWPID 2> /dev/null; then
                /etc/init.d/${SVCNAME} restart
        fi
fi

