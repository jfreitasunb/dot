#!/bin/bash

EXCLUDE_LIST="/Arquivos/OneDrive/Backups/Debian/excludes/exclude-debian.list"

NOME_BACKUP="debian_backup_diario_root_"$(date +%Y-%m-%d)".tar.bz2"

LOCAL_BACKUP="/Arquivos/OneDrive/Backups/Debian/Backup-Diario/"

tar -cjf "$LOCAL_BACKUP""$NOME_BACKUP" /etc

find "$LOCAL_BACKUP""$NOME_BACKUP" -type f -mtime +10 -delete

chown -R jfreitas:jfreitas "$LOCAL_BACKUP"
