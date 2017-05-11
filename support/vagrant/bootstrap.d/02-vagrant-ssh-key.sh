#!/bin/bash
set -e
#set -x

source $SCRIPT_BASE/config.sh

####################################################################################################
# Checks

AUTHORIZED_KEYS="/home/vagrant/.ssh/authorized_keys"

# We should have a list of ssh keys
AUTHORIZED_KEYS_SRC="$SCRIPT_BASE/vagrant-ssh-keys.txt" 

if [ ! -f "$AUTHORIZED_KEYS_SRC" ] ; then
    complain 09 \
        "Could not find the vagrant ssh key list at:\n            %s\n" \
        "$AUTHORIZED_KEYS_SRC"
fi

# The package list should be in unix ff
if egrep -q $'\r' "$AUTHORIZED_KEYS_SRC" ; then
    complain 08 \
        "File has the wrong format (CR characters found):\n            %s\nMaybe git is converting to windows line endings?\n" \
        "$AUTHORIZED_KEYS_SRC"
fi

####################################################################################################
# Install packages

mkdir -p /home/vagrant/.ssh
cat "$AUTHORIZED_KEYS_SRC" >>"$AUTHORIZED_KEYS"
#chown vagrant: "$AUTHORIZED_KEYS"
#chmod 644 "$AUTHORIZED_KEYS"
