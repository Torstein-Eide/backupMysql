#!/bin/bash
# Shell script to backup MySQL database
set -euo pipefail
IFS=$'\n\t'

############################################
###Remember to edit ./db_backup_common.sh###
############################################

# How many days old files must be to be removed
DAYS=31
# Backup Dest directory
DEST="/tmp/test" # edit me

./db_backup_common.sh

# Remove old files
find $DEST -mtime +$DAYS -exec rm -f {} \;

if [ "$FAIL" == "0" ];
then
echo "MySQL backup is ${GREEN}completed without export fail"
else
echo "MySQL backup is ${RED}completed with export $FAIL fails!"
fi

