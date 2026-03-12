#!/bin/bash -x
#Ler: https://bencane.com/2015/09/22/preventing-duplicate-cron-job-executions/
#PIDFILE=/home/jfreitas/.temporario/backup_TARDIS.pid

# Define o caminho para o arquivo de bloqueio
LOCKFILE="/tmp/backup_TARDIS.lock"

# Tenta obter o bloqueio do arquivo. O '-n' faz com que o comando falhe
# imediatamente se o bloqueio não puder ser obtido.

BACKUP_DEVICE="/media/jfreitas/Tardis"

BACKUP_DESTINATION=$BACKUP_DEVICE/"Backup_Rivendel/"

ultimo_backup_tardis=$(cat ~/.temporario/data_ultimo_backup_tardis)

data_atual=$(date '+%s')

ultimo_backup_tardis=$(date -d $ultimo_backup_tardis '+%s')

diferenca=$(((data_atual - ultimo_backup_tardis) / (60 * 60 * 24)))

rotavidade=3

if [ $diferenca -gt $rotavidade ]; then
    if [ -d "$BACKUP_DESTINATION" ]; then
        # O 'exec 200>$LOCKFILE' abre o arquivo de bloqueio no descritor de arquivo 200.
        exec 200>"$LOCKFILE"

        flock -n 200 || {
            echo "Outra instância do script já está em execução."
            exit 1
        }

        # if [ -f $PIDFILE ]; then
        #     PID=$(cat $PIDFILE)
        #     ps -p $PID >/dev/null 2>&1
        #     if [ $? -eq 0 ]; then
        #         exit 1
        #     else
        #         ## Process not found assume not running
        #         echo $$ >$PIDFILE
        #         if [ $? -ne 0 ]; then
        #             exit 1
        #         fi
        #     fi
        # else
        #     echo $$ >$PIDFILE
        #     if [ $? -ne 0 ]; then
        #         exit 1
        #     fi
        # fi

        notify-send "Backup iniciado. Não remova o HD Tardis."

        BACKUP_SOURCE="/home/jfreitas/"

        EXCLUDE_LIST_TARDIS="/home/jfreitas/OneDrive/Backups/Tardis/excludes/exclude-Tardis.list"

        rsync -avzzuc --ignore-existing --delete --delete-excluded --exclude-from="$EXCLUDE_LIST_TARDIS" "$BACKUP_SOURCE" "$BACKUP_DESTINATION"

        umount $BACKUP_DEVICE

        #rm $PIDFILE

        notify-send "Backup finalizado. Pode remover o HD Tardis."

        echo $(date '+%Y-%m-%d') >~/.temporario/data_ultimo_backup_tardis
    fi

fi
