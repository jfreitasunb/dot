#!/bin/bash

ROTATIVIDADE=10

EXCLUDE_LIST="/Arquivos/Dropbox/Backups/Gondor/excludes/exclude-gondor.list"

NOME_BACKUP="gondor_backup_diario_root_"$(date +%Y-%m-%d)".tar.bz2"

LOCAL_TEMPORARIO_ROOT="/Arquivos/Backup_Temporario/Gondor/ROOT/"

LOCAL_TAR="/Arquivos/Backup_Temporario/"

LOCAL_BACKUP="/Arquivos/Dropbox/Backups/Gondor/Backup-Diario/"

#rsync -avzzc --links --delete --exclude-from="$EXCLUDE_LIST" /etc "$LOCAL_TEMPORARIO_ROOT"

#cd "$LOCAL_BACKUP"

tar -cfv "$LOCAL_TAR""$NOME_BACKUP" /etc --exclude-from="$EXCLUDE_LIST"

# rsync -avzc --no-links --delete --exclude-from=$EXCLUDE_LIST /var/lib/vnstat $LOCAL_TEMPORARIO_ROOT

#$cd "$LOCAL_TAR"

#tar -cvjf "$LOCAL_TAR""$NOME_BACKUP" "$LOCAL_TEMPORARIO_ROOT"

#cp "$NOME_BACKUP" "$LOCAL_BACKUP"

chown -R jfreitas:jfreitas "$LOCAL_BACKUP"

#rm "$NOME_BACKUP"
