#!/bin/bash
set -e
#set -x
#echo "XXX Shell: $SHELL"

source $SCRIPT_BASE/config.sh

####################################################################################################
# Checks

SOURCES_LIST="/etc/apt/sources.list"
SOURCES_LIST_D="/etc/apt/sources.list.d"

[ -f "$SOURCES_LIST" ] || \
    complain 01 \
        "Missing system file:\n            %s\nIs this a proper debian system?\n" \
        "$SOURCES_LIST"

[ -d "$SOURCES_LIST_D" ] || \
    complain 01 \
        "Missing system directory:\n            %s\nIs this a proper debian system?\n" \
        "$SOURCES_LIST_D"

# We should have a package list
PACKAGE_LIST="$SCRIPT_BASE/package-list.txt" 

if [ ! -f "$PACKAGE_LIST" ] ; then
    complain 09 \
        "Could not find the package list file at:\n            %s\n" \
        "$PACKAGE_LIST"
fi

# The package list should be in unix ff
if egrep -q $'\r' "$PACKAGE_LIST" ; then
    complain 08 \
        "File has the wrong format (CR characters found):\n            %s\nMaybe git is converting to windows line endings?\n" \
        "$PACKAGE_LIST"
fi

####################################################################################################
# Install packages

cp "$SCRIPT_BASE/etc/apt/sources.list" "$SOURCES_LIST"
cp "$SCRIPT_BASE/etc/apt/sources.list.d/jessie.list" "$SOURCES_LIST_D"

[ -z "$SKIP_PACKAGES" ] && SKIP_PACKAGES=false

if $SKIP_PACKAGES ; then
    echo "Skipping the package update and installation."
    echo "Alter SKIP_PACKAGES in the config to enable it."
else
    pkgmgr_update
    pkgmgr_upgrade
    pkgmgr_install $(cat "$PACKAGE_LIST")
fi
