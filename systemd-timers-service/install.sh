#!/bin/bash
cd "$(dirname "$(readlink -f "$0" || realpath "$0")")"
SYSTEMD=/etc/systemd/system/


function Replace_file {
  if [ -f $SYSTEMD/$1 ]  && [ ! -L $SYSTEMD/$1 ]
then
echo "Moving $SYSTEMD/$1 File for backup"
      mv -v -f $SYSTEMD/$1{,.dtbak}
  fi
  if [[ -e $SYSTEMD/$1 ]] && [[  $(readlink $SYSTEMD/$1) == $PWD/$1 ]]; then
    echo "link to file $1 eksist"
  elif [ -L $SYSTEMD/$1 ]; then
    rm -v $SYSTEMD/$1
    ln -s -v $PWD/$1 $SYSTEMD/$1
  elif [[ ! -e $SYSTEMD/$1 ]]; then
    ln -s -v $PWD/$1 $SYSTEMD/$1
  fi

}

for file in $(find . -maxdepth 1 \( -name "*.timer" -o -name "*.service" \) -type f  -printf "%f\n" ); do
  Replace_file $file &
done

echo "Installed"
