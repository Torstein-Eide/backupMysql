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
your mail, if you wanted to send mail to you. you also need to make sure you have setup `ssmtp`.
* DAYS 
Number of days to save.
* SKIP
Databases to skip.
default is `information_schema` and `performance_schema`
```
Nano db_backup_horly.sh db_backup_daily.sh
```
Output if everything is working:
>```
> #/etc/tilpasset/db_backup_daglig.sh
>list of databases:
>* information_schema
>* mysql
>* performance_schema
>folder /volum/@backup/mysql/daglig exist
>skiping   information_schema
>skiping   performance_schema
>extracted mysql in 0 cpu seconds
>mail not setup
>MySQL backup is completed without export fail

## backup of ubuntu/debian pakages
