# backup of mysql/mariadb
note: this script runs unsecured connection, so don't use it over the internet.

## get the scripts:
```
install -d /etc/scripts
chmod 700 /etc/scripts
cd /etc/scripts
wget https://raw.githubusercontent.com/Eideen/backupMysql/master/db_backup_daily.sh
wget https://raw.githubusercontent.com/Eideen/backupMysql/master/db_backup_common.sh
wget https://raw.githubusercontent.com/Eideen/backupMysql/master/db_backup_horly.sh
chmod +x ./db_backup*.sh
```
## make a backup user:
* HOSTNAME
Server that the script is running on.
* DB_USERNAME
database backup username
* DB_PASSWORD
database backup user passowrd, make a random password.

### A way to make a password:
```
date +%s | sha256sum | base64 | head -c 32 ; echo
```
## On the mysql server:
```
mysql -u root -p
CREATE USER 'DB_USERNAME'@'HOSTNAME' IDENTIFIED BY 'DB_PASSWORD';
GRANT LOCK TABLES, SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER ON *.* TO 'DB_USERNAME'@'HOSTNAME' ;
flush privileges;
```
## edit the scripts to fit your setup:
* DB_USERNAME
database backup username, it is recommend to use a dedicated backup user.
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
default is `information_schema` and `performance_schema`. One line per datebase.
```
Nano db_backup_horly.sh db_backup_daily.sh
```

## Now test your script:
```
/etc/scripts/db_backup_horly.sh
/etc/scripts/db_backup_daily.sh
```
output example:
>```
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

## you can control the content of the backup with the following commands:
 ```
 tar -tvf $DEST/$NOW.tar.gz
 ```
example:
>```
> # tar -tvf /volum/@backup/mysql/daglig/[backupfile].tar.gz
>drwxr-xr-x root/root         0 2018-11-11 11:32 2018-11-11_1132/
>drwx------ root/root         0 2018-11-11 11:32 2018-11-11_1132/mysql/
>-rw-r--r-- root/root       831 2018-11-11 11:32 2018-11-11_1132/mysql/mysql.sql
> ```
## restore database:
 ```
tar -xf [backupfile].tar.gz
cd .[backupfile]/mysql/
mysqladmin -u root -p[root_password] create[database_name]
mysql -u root -p[root_password] [database_name] < dumpfilename.sql
 ```
## Setup crontab:
```
echo "#mysql database backup
32 1 * * * root /etc/scripts/db_backup_daglig.sh > /dev/null 2&>1
44 * * * * root /etc/scripts/db_backup_horly.sh  > /dev/null 2&>1" | tee /etc/cron.d/backup_MYsql
```
### Verfie that cron is working
```
grep "/etc/tilpasset/db_backup_horly.sh" /var/log/syslog
```
