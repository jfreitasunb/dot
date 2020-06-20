#!/bin/bash
#Ler: https://bencane.com/2015/09/22/preventing-duplicate-cron-job-executions/
PIDFILE=/home/jfreitas/.temporario/backup_TARDIS.pid

BACKUP_DEVICE="/run/media/jfreitas/Tardis"

BACKUP_DESTINATION=$BACKUP_DEVICE/"Backup_DROPBOX/"

if [ -d "$BACKUP_DESTINATION" ] ; then

  if [ -f $PIDFILE ]
  then
    PID=$(cat $PIDFILE)
    ps -p $PID > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
      exit 1
    else
      ## Process not found assume not running
      echo $$ > $PIDFILE
      if [ $? -ne 0 ]
      then
          exit 1
      fi
    fi
  else
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
      exit 1
    fi
  fi

  BACKUP_SOURCE="/ArquivosLinux/Dropbox/"

  rsync -avzzc --delete $BACKUP_SOURCE $BACKUP_DESTINATION

  umount $BACKUP_DEVICE
  
  rm $PIDFILE
fi
