#!/bin/bash

# ROTATIVIDADE=10

# NOME_BACKUP_PACMAN="gondor_lista_pacotes_instalados_PACMAN_"$(date +%Y-%m-%d)".lst"

NOME_BACKUP_GNOME="manjaro_gnome_settings_"$(date +%Y-%m-%d)".ini"

# NOME_BACKUP_YAY="gondor_lista_pacotes_instalados_YAY_"$(date +%Y-%m-%d)".lst"
#
NOME_BACKUP_PACMAN="manjaro_lista_pacotes_instalados_PACMAN_"$(date +%Y-%m-%d)".lst"

NOME_BACKUP_PARU="manjaro_lista_pacotes_instalados_PARU_"$(date +%Y-%m-%d)".lst"

LOCAL_BACKUP="/Arquivos/Dropbox/Backups/Manjaro/Backup-Diario/"

# dpkg-query -f '${binary:Package}\n' -W > $LOCAL_BACKUP$NOME_BACKUP

pacman -Qqe | grep -v "$(pacman -Qqm)" > "$LOCAL_BACKUP""$NOME_BACKUP_PACMAN"

pacman -Qqm > "$LOCAL_BACKUP""$NOME_BACKUP_PARU"

sed -i '/paru/d' "$LOCAL_BACKUP""$NOME_BACKUP_PARU"

find "$LOCAL_BACKUP" -type f -mtime +10 -delete

#salva configuraçoes do gnome
dconf dump / > "$LOCAL_BACKUP""$NOME_BACKUP_GNOME"

#importa as configuraçoes do gnome
#dconf load / < dconf-settings.ini

#Para reinstalar
#yay -S - < ~/gondor_lista_pacotes_instalados_YAY.lst
#pacman -S --needed - < ~/gondor_lista_pacotes_instalados_PACMAN.lst
