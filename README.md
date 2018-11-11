# backupSettings
## backup of mysql/mariadb
note: this script runs unsecured connection, so don't use it over the internet.

Some basic Git commands are:
```
install -d /etc/scripts
chmod 700 /etc/scripts
cd /etc/scripts
wget https://raw.githubusercontent.com/Eideen/backupSettings/master/db_backup_daily.sh
wget https://raw.githubusercontent.com/Eideen/backupSettings/master/db_backup_horly.sh
```
edit the scripts to fit your setup:
* DB_USERNAME
database backup username
* DB_PASSWORD
database backup user passowrd
* DB_HOSTNAME
database backup hostname
* DEST
path you wanted to save the backup
* TEMPdir
path to temporary store datebase files before 
* EMAIL
* DAYS 
```
Nano db_backup_horly.sh db_backup_daily.sh
```
## backup of ubuntu/debian pakages
