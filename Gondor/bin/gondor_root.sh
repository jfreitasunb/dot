#!/bin/bash

ROTATIVIDADE=10

EXCLUDE_LIST="/Arquivos/OneDrive - unb.br/Backups/Gondor/excludes/exclude-gondor.list"

LOG="/Arquivos/OneDrive - unb.br/Backups/Gondor/"$(date +%Y-%m-%d)"_log-Backup-ROOT.txt"

NOME_BACKUP="gondor_backup_diario_root_"$(date +%Y-%m-%d)".tar.bz2"

LOCAL_TEMPORARIO_ROOT="/Arquivos/Backup_Temporario/Gondor/ROOT/"

LOCAL_TAR="/Arquivos/Backup_Temporario/"

LOCAL_BACKUP="/Arquivos/OneDrive - unb.br/Backups/Gondor/Backup-Diario/"

rsync -avzzc --links --delete --exclude-from="$EXCLUDE_LIST" /etc "$LOCAL_TEMPORARIO_ROOT"


# rsync -avzc --no-links --delete --exclude-from=$EXCLUDE_LIST /var/lib/vnstat $LOCAL_TEMPORARIO_ROOT

cd "$LOCAL_TAR"

tar -cvjf "$LOCAL_TAR""$NOME_BACKUP" "$LOCAL_TEMPORARIO_ROOT"

cp "$NOME_BACKUP" "$LOCAL_BACKUP"

chown -R jfreitas:jfreitas "$LOCAL_BACKUP"

rm "$NOME_BACKUP"
