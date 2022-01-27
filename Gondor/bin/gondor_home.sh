#!/bin/bash

EXCLUDE_LIST="/Arquivos/OneDrive - unb.br/Backups/Gondor/excludes/exclude-HOME.list"

HOME="/home/jfreitas/"

DEST_HOME_TEMP="/Arquivos/BACKUP-HOME-TEMP/jfreitas/"

DEST_TEMP="/Arquivos/BACKUP-HOME-TEMP/"

DEST_HOME="/Arquivos/OneDrive - unb.br/Backups/Gondor/HOME/"

NOME_BACKUP="gondor_backup_diario_home-jfreitas_"$(date +%Y-%m-%d)".tar.bz2"

rsync -avzz --exclude-from="$EXCLUDE_LIST" "$HOME" "$DEST_HOME_TEMP"

cd "$DEST_TEMP"

tar -cvjf "$DEST_TEMP""$NOME_BACKUP" "$DEST_HOME_TEMP"

split -d -b 1G "$NOME_BACKUP" "$NOME_BACKUP""_part-"

rm "$DEST_TEMP""$NOME_BACKUP"

cp "$DEST_TEMP""$NOME_BACKUP"* "$DEST_HOME"

rm "$DEST_TEMP""$NOME_BACKUP"*

find "$DEST_HOME" -type f -mtime +10 -delete
