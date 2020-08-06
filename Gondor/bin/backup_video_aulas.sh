#!/bin/bash

EXCLUDE_LIST="/Arquivos/OneDrive\ -\ unb.br/Backups/Gondor/excludes/exclude-gondor.list"

LOCAL_SOURCE="/home/jfreitas/Vídeos/Algebra_1"

LOCAL_BACKUP="/Arquivos/OneDrive\ -\ unb.br/UnB/Disciplinas/Graduacao/videos_aulas/"

rsync -avzzc --exclude-from=$EXCLUDE_LIST $LOCAL_SOURCE $LOCAL_BACKUP