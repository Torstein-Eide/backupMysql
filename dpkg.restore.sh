#!/bin/bash

# https://askubuntu.com/questions/9135/how-to-backup-settings-and-list-of-installed-packages

apt-key add ./Repo.keys
cp -R ./sources.list* /etc/apt/
apt-get update
apt-get install dselect
dselect update
dpkg --set-selections < ./Package.list
apt-get dselect-upgrade -y
