#!/bin/bash
# Shell script to backup MySQL database
set -euo pipefail
IFS=$'\n\t'

#Used for Temp folder
export scriptname="$0"

############################################
###Remember to edit ./db_backup_common.sh###
############################################


# How many days old files must be to be removed
HOURS=24
MIN=$(expr $HOURS \* 60)


## Backup Dest directory
export DEST="$HOME/db_backup_hourly" # edit me

./db_backup_common.sh

# Remove old files
find $DEST -mmin +$MIN -exec rm -f {} \;

echo ""
echo "MySQL backup is completed"


