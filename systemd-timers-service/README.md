# script to use with systemed


backup-pgsql-daily.service
backup-pgsql-daily.timer
backup-pgsql-hourly.service
backup-pgsql-hourly.timer

systemctl enable backup-pgsql-daily.timer
systemctl enable backup-pgsql-hourly.timer
systemctl start backup-pgsql-daily.timer
systemctl start backup-pgsql-hourly.timer
