#!/bin/bash
# Shell script to backup MySQL database

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR
IFS=$'\n\t'

##################################
#  Remember to edit ./config.sh  #
##################################
source config.sh

# How many days old files must be to be removed

export DAYS=31

# Backup Dest directory
export DEST="$DESTDIR/db_backup_daily" # edit me


### end of variables

#Used for Temp folder
scriptname="$0"
scriptname=${scriptname::-3}
export scriptname=${scriptname:2}


set -euo pipefail
./db_backup_common.sh


# Remove old files
find $DEST -mtime +$DAYS -exec rm -f {} \;

echo ""
echo "MySQL backup is completed"
