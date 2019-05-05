#!/bin/bash
# Shell script to backup MySQL database
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR


IFS=$'\n\t'



############################################
###Remember to edit ./db_backup_common.sh###
############################################

# How many days old files must be to be removed
export DAYS=31
# Backup Dest directory
export DEST="/volum/@backup/mysql/daglig" # edit me


#Used for Temp folder
scriptname="$0"
scriptname=${scriptname::-3}
export scriptname=${scriptname:2}



./db_backup_common.sh

# Remove old files
find $DEST -mtime +$DAYS -exec rm -f {} \;

echo ""
echo "MySQL backup is completed"

