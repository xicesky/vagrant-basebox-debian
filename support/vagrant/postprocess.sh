#!/usr/bin/env bash
set -e

source /vagrant/support/vagrant/config.sh

####################################################################################################
# Clean up

# Remove cached downloads
apt-get clean

# Clean up user home directories
for DEST_USER in root $VAGRANT_USER ; do
    USER_HOME=$(getent passwd $DEST_USER | cut -d: -f6)
    echo -n >$USER_HOME/.bash_history
done

echo "Cleaning up the disk, this may take a while..."
dd if=/dev/zero of=/EMPTY bs=1M || true     # Errors are ok
rm -f /EMPTY

