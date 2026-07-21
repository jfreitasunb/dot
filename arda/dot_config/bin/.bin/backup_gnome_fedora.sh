#!/bin/bash

NOME_BACKUP_GNOME="fedora_gnome_settings_"$(date +%Y-%m-%d)".ini"

NOME_BACKUP_GNOME_GIT="fedora_gnome_settings.ini"

LOCAL_BACKUP_GIT="/home/jfreitas/GitHub/dot/arda/gnome/"

#salva configuraçoes do gnome

dconf dump / >"$LOCAL_BACKUP_GIT""$NOME_BACKUP_GNOME_GIT"

cd $LOCAL_BACKUP_GIT

git add $NOME_BACKUP_GNOME_GIT

git commit -m "Configurações do Gnome salvas no dia $(date +%d-%m-%Y)"

#importa as configuraçoes do gnome
#dconf load / < dconf-settings.ini

#Para reinstalar
#sudo xargs -a packages_list.txt apt install
