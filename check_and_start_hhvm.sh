#! /bin/bash

if [ "$1" == "" ]; then
        echo "Usage: `basename $0` port"
        exit 1
fi

PORT=$1
PID="`cat /var/run/hhvm/hhvm.${PORT}.pid`"

if [ "$PID" == "" ]; then
        echo No PID, starting up
        /etc/init.d/hhvm.${PORT} restart
else
        if ! kill -0 $PID 2> /dev/null; then
                echo HHVM PID $PID not running, starting up
                # Stop, just in case, if crashed. Else you would get:
                #  * WARNING: hhvm.83 has already been started
                /etc/init.d/hhvm.${PORT} stop
                /etc/init.d/hhvm.${PORT} start
        fi
fi

