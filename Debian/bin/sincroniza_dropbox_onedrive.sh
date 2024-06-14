#!/bin/bash -x

EXCLUDE_LIST="/home/jfreitas/Dropbox/Backups/Gondor/excludes/exclude-BACKUP-DROPBOX.list"

LISTA_DIRETORIOS="/home/jfreitas/Dropbox/Backups/Gondor/OneDrive/lista_diretorios_onedrive.list"

DROPBOX="/home/jfreitas/Dropbox/"

ONEDRIVE="/Windows/Users/josea/OneDrive\ -\ unb.br"

rsync -ravzzc --files-from="$LISTA_DIRETORIOS" --exclude-from="$EXCLUDE_LIST" "$DROPBOX" "$ONEDRIVE" --delete
