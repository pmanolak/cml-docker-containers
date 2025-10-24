#!/bin/sh

LOG_FILE="/var/log/freeradius/cml-radius.log"

if [ -z "$ARGS" ]; then
  ARGS="-f -lstdout"
fi

# wait for a bit to allow the plumbing to be ready
sleep 1

# we want colors with the pipeline...
export TERM=xterm
exec unbuffer /usr/sbin/freeradius ${ARGS} 2>&1 | tee ${LOG_FILE}
