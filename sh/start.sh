#!/bin/sh -e

# Continuously provide logs so that 'docker logs' can    produce them
tail -F "${MINIFI_HOME}/logs/minifi-app.log" &
"${MINIFI_HOME}/bin/minifi.sh" run &
minifi_pid="$!"

trap "echo Received trapped signal, beginning shutdown...;" KILL TERM HUP INT EXIT;

echo MiNiFi running with PID ${minifi_pid}.
wait ${minifi_pid}
