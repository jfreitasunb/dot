#!/bin/bash

ultimo_backup=$(cat ~/.temporario/data_ultimo_backup)
data_atual=$(date '+%s')


data_ultimo_backup=$(date -d $ultimo_backup '+%s')

diferenca=$(( ( data_atual - data_ultimo_backup )/(60*60*24) ))

rotavidade=3

if [ $diferenca -gt $rotavidade ];
then

    EXCLUDE_LIST="/Arquivos/Dropbox/Backups/Gondor/excludes/exclude-HOME.list"

    #HOME="/home/jfreitas/"

    #DEST_HOME_TEMP="/Arquivos/BACKUP-HOME-TEMP/jfreitas/"

    #DEST_TEMP="/Arquivos/BACKUP-HOME-TEMP/"

    #mkdir -p $DEST_TEMP

    DEST_HOME="/Arquivos/Dropbox/Backups/Gondor/HOME/"

    NOME_BACKUP="gondor_backup_diario_home-jfreitas_"$(date +%Y-%m-%d)".tar.bz2"

    #rsync -avzz --exclude-from="$EXCLUDE_LIST" "$HOME" "$DEST_HOME_TEMP"
    cd "$DEST_HOME"

    tar --exclude-from="$EXCLUDE_LIST" -cjf - /home/jfreitas | split -d -b 1G - "$NOME_BACKUP""_parte-"

    find "$DEST_HOME" -type f -mtime +10 -delete

    echo $(date '+%Y-%m-%d') > ~/.temporario/data_ultimo_backup
fi