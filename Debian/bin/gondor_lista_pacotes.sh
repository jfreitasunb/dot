#!/bin/bash

# ROTATIVIDADE=10

# NOME_BACKUP_APT="debian_lista_pacotes_instalados_APT_"$(date +%Y-%m-%d)".lst"

NOME_BACKUP_GNOME="debian_gnome_settings_"$(date +%Y-%m-%d)".ini"

NOME_BACKUP_APT="debian_lista_pacotes_instalados_APT_"$(date +%Y-%m-%d)".lst"

LOCAL_BACKUP="/Arquivos/Dropbox/Backups/Debian/Backup-Diario/"

dpkg-query -f '${binary:Package}\n' -W > $LOCAL_BACKUP$NOME_BACKUP

#pacman -Qqe | grep -v "$(pacman -Qqm)" > "$LOCAL_BACKUP""$NOME_BACKUP_APT"

#pacman -Qqm > "$LOCAL_BACKUP""$NOME_BACKUP_PARU"

#sed -i '/paru/d' "$LOCAL_BACKUP""$NOME_BACKUP_PARU"

find "$LOCAL_BACKUP" -type f -mtime +10 -delete

#salva configuraçoes do gnome
#dconf dump / > "$LOCAL_BACKUP""$NOME_BACKUP_GNOME"

#importa as configuraçoes do gnome
#dconf load / < dconf-settings.ini

#Para reinstalar
#yay -S - < ~/debian_lista_pacotes_instalados_YAY.lst
#pacman -S --needed - < ~/debian_lista_pacotes_instalados_APT.lst
#sudo xargs -a packages_list.txt apt install
