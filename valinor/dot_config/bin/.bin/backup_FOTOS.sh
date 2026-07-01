#!/bin/bash -x
#Ler: https://bencane.com/2015/09/22/preventing-duplicate-cron-job-executions/
#PIDFILE=/home/jfreitas/.temporario/backup_TARDIS.pid

# Define o caminho para o arquivo de bloqueio
LOCKFILE="/tmp/backup_FOTOS.lock"

# Tenta obter o bloqueio do arquivo. O '-n' faz com que o comando falhe
# imediatamente se o bloqueio não puder ser obtido.

BACKUP_DEVICE="/media/jfreitas/Fotos"

BACKUP_DESTINATION="/media/jfreitas/Fotos/"

ultimo_backup_fotos=$(cat ~/.temporario/data_ultimo_backup_fotos)

data_atual=$(date '+%s')

ultimo_backup_fotos=$(date -d $ultimo_backup_fotos '+%s')

diferenca=$(((data_atual - ultimo_backup_fotos) / (60 * 60 * 24)))

rotavidade=3

if [ $diferenca -gt $rotavidade ]; then
    if [ -d "$BACKUP_DESTINATION" ]; then
        # O 'exec 200>$LOCKFILE' abre o arquivo de bloqueio no descritor de arquivo 200.
        exec 200>"$LOCKFILE"

        flock -n 200 || {
            echo "Outra instância do script já está em execução."
            exit 1
        }

        notify-send "Backup iniciado. Não remova o HD Fotos."

        rsync -avzzuc --ignore-existing --delete --delete-excluded /home/jfreitas/OneDrive/Pictures "$BACKUP_DESTINATION"
        
        rsync -avzzuc --ignore-existing --delete --delete-excluded /home/jfreitas/OneDrive/Fotos "$BACKUP_DESTINATION"

        umount $BACKUP_DEVICE

        #rm $PIDFILE

        notify-send "Backup finalizado. Pode remover o HD Fotos."

        echo $(date '+%Y-%m-%d') >~/.temporario/data_ultimo_backup_fotos
    fi

fi
