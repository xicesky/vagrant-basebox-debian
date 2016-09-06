#!/bin/bash
set -e
#set -x
#echo "XXX Shell: $SHELL"

source $SCRIPT_BASE/config.sh

####################################################################################################
# Utility functions

install_home_files() {
    DEST_USER="$1" ; shift
    [ -n "$DEST_USER" ] || complain 01 \
        "install_home_files() was called without parameters.\n"

    USER_HOME=$(getent passwd $DEST_USER | cut -d: -f6)
    [ -d $USER_HOME ] || complain 01 \
        "Missing user home directory.\n    %s\n" \
        "$USER_HOME"

    FILES=$(ls -a "$SCRIPT_BASE/home")
    for FILE in $FILES ; do
        FP="$SCRIPT_BASE/home/$FILE"
        [ \( "$FILE" == "." \) -o \( "$FILE" == ".." \) ] && continue || true
        #echo "    $FP"
        inst "$FP" "$USER_HOME/$FILE" "$DEST_USER"
    done

    # Cache the history on the host machine
    touch "$LOCAL_DIR/.zsh_history"
    ( cd $USER_HOME ; rm -f .zsh_history ; ln -s  "$LOCAL_DIR/.zsh_history" ; chown -h $DEST_USER:$DEST_USER .zsh_history )

}

####################################################################################################
# Checks

####################################################################################################
# Apply settings

# Copy files from the "home" subdirectory (no overwrite)
install_home_files "$VAGRANT_USER"
install_home_files "root"

# Set the users shell
chsh -s /usr/bin/zsh "$VAGRANT_USER"
chsh -s /usr/bin/zsh
