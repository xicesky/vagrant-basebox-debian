#!/bin/bash
set -e
#set -x
#echo "XXX Shell: $SHELL"

source $SCRIPT_BASE/config.sh

####################################################################################################
# Checks

# We should have a install script
INSTALL_SCRIPT="$SCRIPT_BASE/haskell/get-stack.sh"

if [ ! -f "$INSTALL_SCRIPT" ] ; then
    complain 09 \
        "Could not find the install script at:\n            %s\n" \
        "$INSTALL_SCRIPT"
fi

####################################################################################################
# Install packages

# Run the install script
"$INSTALL_SCRIPT"

# The following packages should already be installed:
#   - llvm-3.5
#   - libedit-dev

# Configure stack in /home/vagrant/.stack/config.yaml
# Will be done by the "init-user-prefs" script

# Install a global ghc
sudo -u $VAGRANT_USER stack setup
