#!/bin/bash
IFS="
"

DIR=$HOME/Documents/Clients
BACKUPHOME=$HOME/backup/Clients

cd $DIR
for CLIENT in $(ls -1 $DIR)
do
    if [ -d $DIR/$CLIENT ]
    then
        echo $CLIENT
        DATE=$(date '+%y%m%d_%H%M')
        NAME=$(echo $CLIENT | sed 's/ /_/g')
        TAR=${NAME}_$DATE.tgz
        [ -d $BACKUPHOME/$NAME ] || mkdir -p $BACKUPHOME/$NAME
        tar zcvfp $BACKUPHOME/$NAME/$TAR $CLIENT
    fi
done
rsync -avPe ssh $BACKUPHOME nas:/storage/backup/
