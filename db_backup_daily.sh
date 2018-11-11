#!/bin/bash
# Shell script to backup MySQL database
set -euo pipefail
IFS=$'\n\t'

#control for dependeces
# Linux bin paths
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
Pigz="$(which pigz)"

if [ -e $Pigz ] || [ -e $MYSQL ] || [ -e $MYSQLDUMP ]
then
 echo "missing dependeces"
  apt install pigz mysqldump mariadb-client
  fi


#Text Colors
GREEN=`tput setaf 2`
RED=`tput setaf 1`
NC=`tput sgr0` #No color

#Output Strings
GOOD="${GREEN}NO${NC}"
BAD="${RED}YES${NC}"

# Set these variables
MyUSER="backup"	# DB_USERNAME # edit me
MyPASS="password"	# DB_PASSWORDc
MyHOST="localhost"	# DB_HOSTNAME # edit me

# Backup Dest directory
DEST="/volum/@backup/mysql/hour" # edit me
TEMPdir="/tmp/mysql/time"

# Email for notifications
EMAIL=

# How many days old files must be to be removed
DAYS=31



# Get date in yyyy-mm-dd_HHmm format
NOW="$(date +"%Y-%m-%d_%H%M")"

# Create Backup sub-directories
MBD="$TEMPdir/$NOW/mysql"

# DB skip list
SKIP="information_schema
performance_schema
another_one_db"

# Get all databases
DBS="$($MYSQL -h $MyHOST -u $MyUSER -p$MyPASS -Bse 'show databases')"
echo -e "${NC}list of databases:"
for i in $DBS
do
	echo "* $GREEN$i${NC}"
done
#\n$GREEN$DBS${NC}


#make temp dir
install -d $MBD
chmod 700 $MBD


#make dir
if [ ! -d $DEST ]
echo "Directory does not $DEST exist, making dir"
mkdir -v $DEST || echo "problem exiting" | exit
chmod 700 $DEST
fi

dbdump() {
skipdb=-1
SECONDS=0
if [ "$db" == "mysql" ];
  then
   SKIPLOG="--skip-lock-tables"
  else
   SKIPLOG=""
 fi

if [ "$SKIP" != "" ];
  then
    for i in $SKIP
     do
      [ "$db" == "$i" ] && skipdb=1 || :
     done
    fi

    if [ "$skipdb" == "-1" ]
     then
        FILE="$MBD/$db.sql"
        $MYSQLDUMP -h $MyHOST -u $MyUSER -p$MyPASS $db > $FILE 
        echo "extracted $GREEN$db${NC} in $SECONDS"
     else
        echo "skiping   $RED$db${NC}"
    fi
}

# Archive database dumps
echo "extracting databases:"
for db in $DBS
do
dbdump &
done
FAIL=0
#jobs verbose
#for job in `jobs -p`
#do
#    wait $job || let "FAIL+=1"
#done
wait
echo "extraction ${GREEN}done${NC}"
# Archive the directory, send mail and cleanup
cd $TEMPdir
tar -I pigz -cf $DEST/$NOW.tar.gz $NOW
#$GZIP -9 $NOW.tar

if [ -n "$EMAIL" ]
then
echo "sant"
        echo "
        To: $EMAIL
        Subject: MySQL backup
        MySQL backup is completed! Backup name is $NOW.tar.gz" | ssmtp $EMAIL

else
echo "${RED}mail not setup${NC}"
fi

#remove temp file
rm -rf $TEMPdir

# Remove old files
find $DEST -mtime +$DAYS -exec rm -f {} \;

if [ "$FAIL" == "0" ];
then
echo "MySQL backup is ${GREEN}completed without export fail"
else
echo "MySQL backup is ${RED}completed with export $FAIL fails!"
fi

