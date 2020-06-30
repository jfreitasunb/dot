#!/bin/bash

ROTATIVIDADE=10

EXCLUDE_LIST="/ArquivosLinux/Dropbox/Backups/Gondor/excludes/exclude-gondor.list"

LOCAL_SOURCE="/home/jfreitas/Vídeos/Algebra_1/"

LOCAL_BACKUP="/ArquivosLinux/Dropbox/UnB/Disciplinas/Graduacao/Algebra_1/2020-1/videos_aulas"

rsync -avzzc --delete --exclude-from=$EXCLUDE_LIST $LOCAL_SOURCE $LOCAL_BACKUP