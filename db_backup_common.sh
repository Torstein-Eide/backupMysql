# THIS the common config file, do not run this directly


info() {
     echo "$( $date ): $* "  
}
warnings(){ 
    echo -e "\033[93m$( $date ): $* \033[0m"
}
error(){ 
    echo -e "\033[91m$( $date ): $* \033[0m"
}


#control for dependeces
# Linux bin paths
MARIADB="$(which mariadb)"
MARIADUMP="$(which mariadb-dump)"
ZSTD="$(which zstd)"

if [ -z $ZSTD ] || [ -z $MARIADB ] || [ -z $MARIADUMP ]
then
 warnings "missing dependeces, installing dependeces"
 apt install zstd mariadb-client || error "missing dependeces, unable to install" && exit 1
fi
set -euo pipefail

function cleanup {
 #remove temp file
 info "cleanup"
 info "removing $TEMPdir"
 rm -r $TEMPdir
}

# Trap Ctrl-C & Ctrl-\ to clean up
trap 'error "Backup interrupted >&2"; cleanup; exit 2' INT TERM

# Set the number of threads for zstd to 2 times the number of threads
zstd_threads=$((1 * $(nproc)))

# Get date in dd-mm-yyyy format
NOW="$(date +"%Y-%m-%d_%H%M")"


# Get all databases
DBS="$($MARIADB -h $MyHOST -u $MyUSER -p$MyPASS -Bse 'show databases')"
info "list of databases:"
for i in $DBS; do
    info "* ${i}"
done

# Create Backup sub-directories
MBD="${TEMPdir}/mysql"

#make temp dir
install -d $MBD
chmod 700 $MBD


#make dir
if [ ! -d $DEST ]; then
	warnings "Directory does not $DEST exist, making dir"
	mkdir -v $DEST || error "problem creating $DEST, exiting" | exit
	chmod 700 $DEST || error "problem chmod 700 $DEST, exiting" | exit
else
	info "Directory $DEST exist"
fi


dbdump() {
skipdb=-1
START="$(date "+%s%N")"
if [ "$db" == "mariadb" ]; then
   SKIPLOG="--skip-lock-tables"
else
   SKIPLOG=""
fi

if [ "$SKIP" != "" ]; then
    for i in $SKIP; do
      [ "$db" == "$i" ] && skipdb=1 || :
    done
fi

if [ "$skipdb" == "-1" ]; then
    FILE="$MBD/$db.sql"
    $MARIADUMP -h $MyHOST -u $MyUSER -p$MyPASS $db > $FILE || error "problem dumping database $db" && exit 1
		TT=$(printf %.4f "$(("$(date "+%s%N")" - $START))e-9")
		info "extracted $db, $TT s"

else
    info "skiping $db"
fi
}

# Archive database dumps
for db in $DBS; do
  dbdump &
done
wait
# Archive the directory, send mail and cleanup
DEST_TAR="$DEST/$NOW.tar.zstd"
cd $TEMPdir
du -hs $TEMPdir
tar_I="zstd --adapt=max=15 -$compression_level -T${zstd_threads}"
tar -I "$tar_I" -cf $DEST_TAR $NOW
du -hs $DEST_TAR
ln -fvs  $NOW.tar.zstd $DEST/latest.tar.zstd
ln -fvs  $DEST_TAR $DESTDIR/latest.tar.zstd

# Clean up tmp files.
cleanup

if [ -n "$EMAIL" ]
then
echo "sant"
        echo "
        To: $EMAIL
        Subject: MySQL backup
        MySQL backup is completed! Backup name is $NOW.tar.zstd" | ssmtp $EMAIL

else
info "mail not setup"
fi
info "Backup finished successfully"
