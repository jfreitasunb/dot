#!/bin/bash

# ROTATIVIDADE=10

# NOME_BACKUP_PACMAN="gondor_lista_pacotes_instalados_PACMAN_"$(date +%Y-%m-%d)".lst"

NOME_BACKUP_GNOME="gondor_gnome_settings_"$(date +%Y-%m-%d)".ini"

# NOME_BACKUP_YAY="gondor_lista_pacotes_instalados_YAY_"$(date +%Y-%m-%d)".lst"
# 
NOME_BACKUP_PACMAN="gondor_lista_pacotes_instalados_PACMAN.lst"

NOME_BACKUP_YAY="gondor_lista_pacotes_instalados_YAY.lst"

LOCAL_BACKUP="/Arquivos/OneDrive/Backups/Gondor/Backup-Diario/"

# dpkg-query -f '${binary:Package}\n' -W > $LOCAL_BACKUP$NOME_BACKUP

pacman -Qqe | grep -v "$(pacman -Qqm)" > "$LOCAL_BACKUP""$NOME_BACKUP_PACMAN"

pacman -Qqm > "$LOCAL_BACKUP""$NOME_BACKUP_YAY"

sed -i '/yay/d' "$LOCAL_BACKUP""$NOME_BACKUP_YAY"

#salva configuraçoes do gnome
dconf dump / > "$LOCAL_BACKUP""$NOME_BACKUP_GNOME"

#importa as configuraçoes do gnome
#dconf load / < dconf-settings.ini

#Para reinstalar
#yay -S - < ~/gondor_lista_pacotes_instalados_YAY.lst
#pacman -S --needed - < ~/gondor_lista_pacotes_instalados_PACMAN.lst