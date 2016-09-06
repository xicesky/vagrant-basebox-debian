#!/usr/bin/env bash
set -e
#set -x
#echo "XXX Shell: $SHELL"

source /vagrant/support/vagrant/config.sh

####################################################################################################
# Checks

[ `whoami` == 'root' ] || complain 01 \
    "This script must be run as root."

####################################################################################################
# Infos about the the base box

#echo   "-------------------------------------------------------------------------------"
#echo   "Info:"
#echo   "    SUPPORT_OLD_BOX             :   $SUPPORT_OLD_BOX"
#echo   "    INSTALLED_SYSTEM_NAME       :   $INSTALLED_SYSTEM_NAME"
#echo   "    INSTALLED_SYSTEM_RELEASE    :   $INSTALLED_SYSTEM_RELEASE"
#echo   "    INSTALLED_POSTGRESQL        :   $INSTALLED_POSTGRESQL"
#echo   "-------------------------------------------------------------------------------"

####################################################################################################
# Actually run the bootstrap scripts

cd $SCRIPT_BASE
run-parts --verbose --regex='\.sh$' --exit-on-error bootstrap.d
