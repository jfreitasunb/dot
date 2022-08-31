#!/bin/bash -x

EXCLUDE_LIST="/Arquivos/Dropbox/Backups/Gondor/excludes/exclude-BACKUP-DROPBOX.list"

LISTA_DIRETORIOS="/Arquivos/Dropbox/Backups/Gondor/OneDrive/lista_diretorios_onedrive.list"

DROPBOX="/Arquivos/Dropbox/"

ONEDRIVE="/Arquivos/OneDrive/"

rsync -ravzzc --files-from="$LISTA_DIRETORIOS" --exclude-from="$EXCLUDE_LIST" "$DROPBOX" "$ONEDRIVE" --delete
