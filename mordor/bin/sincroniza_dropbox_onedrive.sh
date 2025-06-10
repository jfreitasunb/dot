#!/bin/bash -x

EXCLUDE_LIST="/Arquivos/Dropbox/Backups/Gondor/excludes/exclude-BACKUP-DROPBOX.list"

LISTA_DIRETORIOS="/Arquivos/Dropbox/Backups/Gondor/OneDrive/lista_diretorios_onedrive.list"

LOG_BACKUP="/home/jfreitas/log_sincronizacao_dropbox-onedrive_"$(date +%Y_%m_%d)

DROPBOX="/Arquivos/Dropbox/"

ONEDRIVE="/Arquivos/OneDrive/"

rm $LOG_BACKUP

touch $LOG_BACKUP

echo "========================================================" >> $LOG_BACKUP

echo "Backup iniciado às "$(date +%H:%M:%S)" do dia "$(date +%m/%d/%Y) >> $LOG_BACKUP

echo "========================================================" >> $LOG_BACKUP

rsync -ravzzc --log-file="$LOG_BACKUP" --files-from="$LISTA_DIRETORIOS" --exclude-from="$EXCLUDE_LIST" "$DROPBOX" "$ONEDRIVE" --delete

echo "========================================================" >> $LOG_BACKUP

echo "Backup finalizado às "$(date +%H:%M:%S)" do dia "$(date +%m/%d/%Y) >> $LOG_BACKUP

echo "========================================================" >> $LOG_BACKUP

if [ -e $LOG_BACKUP ]
then
	mv $LOG_BACKUP $DROPBOX"/Logs_sincronizacao/
fi
