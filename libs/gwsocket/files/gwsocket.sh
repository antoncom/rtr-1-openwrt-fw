#!/bin/sh

INITFILE=/etc/init.d/gwsocket
SERVICE_PID_FILE=/var/run/gwsocket.pid
APP=$0

usage() {
    echo "Usage: $APP [ COMMAND [ OPTIONS ] ]"
    echo
    echo "Commands are:"
    echo "    start|stop|restart|reload     controlling the daemon"
    echo "    help                          show this and exit"
    doexit
}
callinit() {
    [ -x $INITFILE ] || {
        echo "No init file '$INITFILE'"
        return
    }
    exec $INITFILE $1
    RETVAL=$?
}
run() {
    exec /usr/bin/gwsocket
    RETVAL=$?
}

doexit() {
    exit $RETVAL
}

[ -n "$INCLUDE_ONLY" ] && return

CMD="$1"
[ -z $CMD ] && {
    run
    doexit
}
shift
# See how we were called.
case "$CMD" in
    start|stop|restart|reload)
        callinit $CMD
        ;;
    *help|*?)
        usage $0
        ;;
    *)
        RETVAL=1
        usage $0
        ;;
esac

doexit
