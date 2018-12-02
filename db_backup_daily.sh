#!/bin/bash
# Shell script to backup MySQL database
set -euo pipefail
IFS=$'\n\t'
export scriptname="$0"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

############################################
###Remember to edit ./db_backup_common.sh###
############################################

# How many days old files must be to be removed
export DAYS=31
# Backup Dest directory
export DEST="$HOME/db_backup_daily" # edit me

./db_backup_common.sh

# Remove old files
find $DEST -mtime +$DAYS -exec rm -f {} \;

echo ""
echo "MySQL backup is completed"

