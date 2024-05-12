# Set these variables
export MyUSER="backup"	# DB_USERNAME # edit me
export MyPASS="0123456789"	# DB_PASSWORDc
export MyHOST="localhost"	# DB_HOSTNAME # edit me

# Backup parent dest directory
export DESTDIR="/volum1/@backup/mysql"

#Tempfolder for databases will tarballing.
export TEMPdir="$(mktemp -d)"

# Email for notifications
export EMAIL=

# Default compression level
export compression_level=6

# DB skip list
export SKIP="information_schema
performance_schema
another_one_db"
