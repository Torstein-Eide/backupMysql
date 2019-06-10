#!/bin/sh
# Shell script to backup MySQL database
set -euo pipefail
IFS=$'\n\t'

############################################
###Remember to edit ./db_backup_common.sh###
############################################

# How many days old files must be to be removed
DAYS=31
# Backup Dest directory
<<<<<<< Updated upstream
export DEST="$HOME/db_backup_daily" # edit me

=======
export DEST="/volum1/@backup/mysql/daglig" # edit me
>>>>>>> Stashed changes



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

#  Used for Temp folder
scriptname="$0"
scriptname=${scriptname::-3}
export scriptname=${scriptname:2}

./db_backup_common.sh

# Remove old files
find $DEST -mtime +$DAYS -exec rm -f {} \;

echo ""
echo "MySQL backup is completed"
