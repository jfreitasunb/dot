#!/bin/bash

ultimo_backup=$(cat ~/.temporario/data_ultimo_backup)

data_atual=$(date '+%s')

data_ultimo_backup=$(date -d $ultimo_backup '+%s')

diferenca=$(( ( data_atual - data_ultimo_backup )/(60*60*24) ))

rotavidade=3

if [ $diferenca -gt $rotavidade ];
then

    EXCLUDE_LIST="/Arquivos/OneDrive/Backups/Debian/excludes/exclude-HOME.list"

    DEST_HOME="/Arquivos/OneDrive/Backups/Debian/HOME/"

    NOME_BACKUP="debian_backup_diario_home-jfreitas_"$(date +%Y-%m-%d)".tar.bz2"

    cd "$DEST_HOME"

    tar --exclude-from="$EXCLUDE_LIST" -cjf - /home/jfreitas | split -d -b 4G - "$NOME_BACKUP""_parte-"

    find "$DEST_HOME" -type f -mtime +10 -delete

    echo $(date '+%Y-%m-%d') > ~/.temporario/data_ultimo_backup
fi
