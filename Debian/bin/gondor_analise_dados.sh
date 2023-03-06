#!/bin/bash -x

EXCLUDE_LIST_DADOS="/Arquivos/Dropbox/Backups/Gondor/excludes/exclude-analise_dados.list"

DEST_ANALISEDADOS="/Arquivos/Dropbox/"

ANALISEDADOS="/home/jfreitas/analise_de_dados"

rsync -avzz --exclude-from="$EXCLUDE_LIST_DADOS" "$ANALISEDADOS" "$DEST_ANALISEDADOS"
