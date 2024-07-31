#!/bin/bash

NOME_BACKUP_GNOME="arch_gnome_settings_"$(date +%Y-%m-%d)".ini"

NOME_BACKUP_YAY="arch_lista_pacotes_instalados_YAY_"$(date +%Y-%m-%d)".lst"

NOME_BACKUP_PACMAN="arch_lista_pacotes_instalados_PACMAN_"$(date +%Y-%m-%d)".lst"

LOCAL_BACKUP="/Arquivos/Dropbox/Backups/Arch/Backup-Diario/"

pacman -Qqe | grep -v "$(pacman -Qqm)" > "$LOCAL_BACKUP""$NOME_BACKUP_PACMAN"

pacman -Qqm > "$LOCAL_BACKUP""$NOME_BACKUP_PARU"

sed -i '/yay/d' "$LOCAL_BACKUP""$NOME_BACKUP_PARU"

find "$LOCAL_BACKUP" -type f -mtime +10 -delete

#salva configuraçoes do gnome
dconf dump / > "$LOCAL_BACKUP""$NOME_BACKUP_GNOME"

#importa as configuraçoes do gnome
#dconf load / < dconf-settings.ini

#Para reinstalar
#yay -S - < ~/gondor_lista_pacotes_instalados_YAY.lst
#pacman -S --needed - < ~/gondor_lista_pacotes_instalados_PACMAN.lst
