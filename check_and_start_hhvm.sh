#! /bin/bash

if [ "$1" == "" ]; then
        echo "Usage: `basename $0` svcname"
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

PID="`cat /var/run/hhvm/${SVCNAME}.pid`"

if [ "$PID" == "" ]; then
        echo No PID, starting up
        /etc/init.d/${SVCNAME} restart
else
        if ! kill -0 $PID 2> /dev/null; then
                echo HHVM PID $PID not running, starting up
                # Stop, just in case, if crashed. Else you would get:
                #  * WARNING: hhvm.83 has already been started
                /etc/init.d/${SVCNAME} stop
                /etc/init.d/${SVCNAME} start
        fi
fi

