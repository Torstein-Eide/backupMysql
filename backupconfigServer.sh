#!/bin/bash
if [ $EUID != 0 ]; then
            echo "Script must be run as user: root"
			exit
  fi
#Text Colors
GREEN=`tput setaf 2`
RED=`tput setaf 1`
NC=`tput sgr0` #No color

#Output Strings
GOOD="${GREEN}NO${NC}"
BAD="${RED}YES${NC}"
  
  
  
echo -n ${NC}"input username for remote server: "$GREEN
read username

echo -n ${NC}"input remote server address: "$GREEN
read SA

echo -n ${NC}"input remote server port: "$GREEN
read port

echo -n ${NC}"input remote server shortname: "$GREEN
read ServerShortname
 
echo -n ${NC}"This script will put the mount in directory with the same name hostname as this server. (currently $(hostname))
input remote server Backup directory (example: /backup): "$GREEN
read Backupdir

 echo -n ${NC}"input local mount point for Backup directory (example: /mnt/backup): "$GREEN
read mountpount
 
# "&& echo file exists " for true || for not true
if [ ! -e ~/.ssh/id_rsa.pub ]
then
echo "${RED}~/.ssh/id_rsa does not exists$NC, running first time setup for $GREENssh-keygen (~/.ssh/id_rsa), ssh-copy-id and ~/.ssh/config"$NC
ssh-keygen
else 
echo "~/.ssh/id_rsa.pub exsits"
fi
echo "copying publinc key to remote host, and adding it to ~/.ssh/authorized_keys"
cat /root/.ssh/id_rsa.pub | ssh $username@$SA -p $port "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys" || exit

if [ ! -e ~/root/.ssh/config ]
then
touch /root/.ssh/config
echo -e "
host\t$ServerShortname
\thostname\t$SA
\tIdentityFile\t~/.ssh/id_rsa
\tuser\t\t$username
\tport\t\t$port
" >> /root/.ssh/config
fi
#~/.ssh/config
# host	ServerShortname 
# 	hostname		Serveraddress
# 	IdentityFile	~/.ssh/id_rsa
# 	user			username
# 	port			port


if hash sshfs  2>/dev/null; then
        echo "sshfs installed"
 else
        echo "sshfs not installed, running 'sudo apt update; sudo apt install sshfs'"
		apt update
		apt install
    fi


test -e $mountpount&& echo "$mountpount exist" ||mkdir -p $mountpount; echo "making directory $mountpount" 

mkdir $Backupdir
sshfs -p $port $shortname:$Backupdir $mountpount || exit
mkdir $Backupdir/"$(hostname)"|| exit
umount $Backupdir|| exit
sshfs -p $port $shortname:$Backupdir/"$(hostname)" $mountpount || exit



echo -e "$ServerShortname:$Backupdir/$(hostname)\t\t$mountpount\tfuse.sshfs\tdelay_connect,defaults,allow_other,_netdev,reconnect\t0\t0" >> /etc/fstab

# mkdir $homedir
# sshfs -p port $username@$SA:/home $homedir
# homedir="/mnt/home" 
# echo "$ServerShortname :/home/  				/mnt/home/  	fuse.sshfs  delay_connect,defaults,allow_other,_netdev,reconnect  0  0" >> /etc/fstab
