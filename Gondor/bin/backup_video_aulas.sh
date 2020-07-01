#!/bin/bash

ROTATIVIDADE=10

EXCLUDE_LIST="/ArquivosLinux/Dropbox/Backups/Gondor/excludes/exclude-gondor.list"

LOCAL_SOURCE="/home/jfreitas/Vídeos/Algebra_1/"

LOCAL_BACKUP="/ArquivosLinux/Dropbox/UnB/Disciplinas/Graduacao/videos_aulas"

rsync -avzzc --delete --exclude-from=$EXCLUDE_LIST $LOCAL_SOURCE $LOCAL_BACKUP