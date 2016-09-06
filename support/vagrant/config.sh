#!/usr/bin/env bash
set -e
#set -x
#echo "XXX Shell: $SHELL"

####################################################################################################
# Variables / "Configuration"

VAGRANT_USER="vagrant"
PROJECT_ROOT="/vagrant"
SCRIPT_BASE="$PROJECT_ROOT/support/vagrant"
LOCAL_DIR="$PROJECT_ROOT/local"
POSTGRESQL_VERSION="9.4"

export VAGRANT_USER
export PROJECT_ROOT
export SCRIPT_BASE
export LOCAL_DIR
export POSTGRESQL_VERSION

####################################################################################################
# Utility functions

complain() {
    CODE="$1"
    shift
    printf "$@" 1>&2
    exit $CODE
}

export -f complain

pkgmgr_update() {
    aptitude update
}

export -f pkgmgr_update

pkgmgr_upgrade() {
    aptitude dist-upgrade -y
}

export -f pkgmgr_upgrade

pkgmgr_install() {
    aptitude install -y "$@"
}

export -f pkgmgr_install

pkgmgr_remove() {
    aptitude purge -y "$@"
}

export -f pkgmgr_remove

inst() {
    FORCE=false
    if [ "$1" == "-f" ] ; then
        FORCE=true
        shift
    fi
    SOURCE="$1" ; shift
    DESTINATION="$1" ; shift
    OWNER="$1" ; shift || true
    MODE="$1" ; shift || true
    [ -e "$SOURCE" ] || return 0
    $FORCE || [ ! -e "$DESTINATION" ] || return 0
    cp -rv "$SOURCE" "$DESTINATION"
    if [ -n "$OWNER" ] ; then
        chown -R "$OWNER:" "$DESTINATION"
    fi
    if [ -n "$MODE" ] ; then
        chmod -R "$MODE" "$DESTINATION"
    fi
}

export -f inst

