#!/bin/bash

EXCLUDE_LIST="/home/jfreitas/OneDrive/Backups/Arch/excludes/exclude-gondor.list"

NOME_BACKUP="arch_backup_diario_root_"$(date +%Y-%m-%d)".tar.bz2"

LOCAL_BACKUP="/home/jfreitas/OneDrive/Backups/Arch/Backup-Diario/"

tar --exclude-from="$EXCLUDE_LIST" -cjf "$LOCAL_BACKUP""$NOME_BACKUP" /etc

chown -R jfreitas:jfreitas "$LOCAL_BACKUP"
