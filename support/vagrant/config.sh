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

# Also force apt to avoid interactive prompts
DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

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

pkgmgr_install_deb() {
    dpkg -i "$@"
}

export -f pkgmgr_install_deb

pkgmgr_remove() {
    aptitude purge -y "$@"
}

export -f pkgmgr_remove

# Usage inst [-f] SOURCE DESTINATION [OWNER] [MODE]
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

