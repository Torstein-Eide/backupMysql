#!/bin/sh
# Shell script to backup MySQL database
set -euo pipefail
IFS=$'\n\t'

##############################################
### Remember to edit ./db_backup_common.sh ###
##############################################

# How many days old files must be to be removed
HOURS=24

## Backup Dest directory
export DEST="$HOME/db_backup_hourly" # edit me

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR
#Used for Temp folder
scriptname="$0"
scriptname=${scriptname::-3}
export scriptname=${scriptname:2}

./db_backup_common.sh

# Convert hours inn to minutts for find
MIN=$(expr $HOURS \* 60)
# Remove old files
find $DEST -mmin +$MIN -exec rm -f {} \;

echo ""
echo "MySQL backup is completed"
