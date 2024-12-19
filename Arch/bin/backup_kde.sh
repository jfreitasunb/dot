#!/bin/bash -x

data_hoje=$(date +%Y-%m-%d)

konsave -s backup_$data_hoje

cd ~/.config/konsave/profiles/

cp -R backup_$data_hoje/* /home/jfreitas/GitHub/dot/Arch/KDE-configs/

cd /home/jfreitas/GitHub/dot/Arch/KDE-configs/

git commit -am "Ajustes nas configurações do KDE feitas no dia "$data_hoje

# EXCLUDE_LIST="/home/jfreitas/OneDrive/Backups/Arch/excludes/exclude-HOME.list"

# DEST_HOME="/home/jfreitas/OneDrive/Backups/Arch/HOME/"

# NOME_BACKUP="arch_backup_diario_home-jfreitas_"$data_hoje".tar.bz2"

# cd "$DEST_HOME"

# tar --exclude-from="$EXCLUDE_LIST" -cjf - /home/jfreitas | split -d -b 4G - "$NOME_BACKUP""_parte-"

# find "$DEST_HOME" -type f -mtime +10 -delete

# echo $(date '+%Y-%m-%d') > ~/.temporario/data_ultimo_backup

