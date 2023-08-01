#!/bin/bash

NOME_BACKUP_GNOME="debian_gnome_settings_"$(date +%Y-%m-%d)".ini"

NOME_BACKUP_APT="debian_lista_pacotes_instalados_APT_"$(date +%Y-%m-%d)".lst"

LOCAL_BACKUP="/Arquivos/Dropbox/Backups/Debian/Backup-Diario/"

dpkg-query -f '${binary:Package}\n' -W > $LOCAL_BACKUP$NOME_BACKUP

find "$LOCAL_BACKUP" -type f -mtime +10 -delete

#salva configuraçoes do gnome
dconf dump / > "$LOCAL_BACKUP""$NOME_BACKUP_GNOME"

#importa as configuraçoes do gnome
#dconf load / < dconf-settings.ini

#Para reinstalar
#sudo xargs -a packages_list.txt apt install
