#!/bin/bash -x

EXCLUDE_LIST_DADOS="/home/jfreitas/OneDrive/Backups/Gondor/excludes/exclude-analise_dados.list"

DEST_ANALISEDADOS="/home/jfreitas/OneDrive/"

ANALISEDADOS="/home/jfreitas/analise_de_dados"

rsync -avzz --exclude-from="$EXCLUDE_LIST_DADOS" "$ANALISEDADOS" "$DEST_ANALISEDADOS"
