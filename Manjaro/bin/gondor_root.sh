#!/bin/bash

ROTATIVIDADE=10

EXCLUDE_LIST="/Arquivos/Dropbox/Backups/Manjaro/excludes/exclude-gondor.list"

NOME_BACKUP="manjaro_backup_diario_root_"$(date +%Y-%m-%d)".tar.bz2"

LOCAL_BACKUP="/Arquivos/Dropbox/Backups/Manjaro/Backup-Diario/"

#rsync -avzzc --links --delete --exclude-from="$EXCLUDE_LIST" /etc "$LOCAL_TEMPORARIO_ROOT"

#cd "$LOCAL_BACKUP"

tar --exclude-from="$EXCLUDE_LIST" -cjf "$LOCAL_BACKUP""$NOME_BACKUP" /etc

# rsync -avzc --no-links --delete --exclude-from=$EXCLUDE_LIST /var/lib/vnstat $LOCAL_TEMPORARIO_ROOT

#$cd "$LOCAL_TAR"

#tar -cvjf "$LOCAL_TAR""$NOME_BACKUP" "$LOCAL_TEMPORARIO_ROOT"

#cp "$NOME_BACKUP" "$LOCAL_BACKUP"

chown -R jfreitas:jfreitas "$LOCAL_BACKUP"

#rm "$NOME_BACKUP"
