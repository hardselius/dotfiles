#!/usr/bin/env bash
QLFILE=$1

# we have to trap ctrl-c so that a successful exit signal will be given,
# so that mutt won't prompt us to press any key to continue
trap 'exit 0' 2 #traps Ctrl-C (signal 2)

qlmanage -p $QLFILE >& /dev/null
