#!/bin/bash -x

ROTATIVIDADE=10

EXCLUDE_LIST="/Arquivos/OneDrive - unb.br/Backups/Gondor/excludes/exclude-gondor.list"

LOG="/Arquivos/OneDrive - unb.br/Backups/Gondor/"$(date +%Y-%m-%d)"_log-Backup-ROOT.txt"

NOME_BACKUP="gondor_backup_diario_root_"$(date +%Y-%m-%d)".tar.bz2"

LOCAL_TEMPORARIO_ROOT="/VMs/Backup_Temporario/Gondor/ROOT/"

LOCAL_TAR="/VMs/Backup_Temporario/"

LOCAL_BACKUP="/Arquivos/OneDrive - unb.br/Backups/Gondor/Backup-Diario/"

rsync -avzzc --links --delete --exclude-from="$EXCLUDE_LIST" /etc "$LOCAL_TEMPORARIO_ROOT"


# rsync -avzc --no-links --delete --exclude-from=$EXCLUDE_LIST /var/lib/vnstat $LOCAL_TEMPORARIO_ROOT

cd "$LOCAL_TAR"

tar -cvjf "$LOCAL_TAR""$NOME_BACKUP" "$LOCAL_TEMPORARIO_ROOT"

cp "$NOME_BACKUP" "$LOCAL_BACKUP"

chown -R jfreitas:jfreitas "$LOCAL_BACKUP"

# rm $NOME_BACKUP

# HOJE=$(date +'%Y-%m-%d')

# for filename in $LOCAL_BACKUP*.tar.bz2; do

#     DATAARQUIVO=$(echo $filename | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')

#     DIFERENCA=$(($(($(date -d $HOJE "+%s") - $(date -d $DATAARQUIVO "+%s")))  / 86400 ))

#     if [[ $DIFERENCA -ge $ROTATIVIDADE ]]; then
#         rm -f $filename
#     fi
# done