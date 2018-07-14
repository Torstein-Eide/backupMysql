#!/bin/bash

# https://askubuntu.com/questions/9135/how-to-backup-settings-and-list-of-installed-packages

apt-key add ./Repo.keys
cp -R ./sources.list* /etc/apt/
apt-get update
apt-get install dselect
dselect update
dpkg --set-selections < ./Package.list
apt-get dselect-upgrade -y

# You may have to update dpkg's list of available packages or\
#it will just ignore your selections (see this debian bug for more info).\
#You should do this before sudo dpkg --set-selections < ~/Package.list, like this:
#apt-cache dumpavail > ./temp_avail
#sudo dpkg --merge-avail ./temp_avail
#s3rm ./temp_avail
