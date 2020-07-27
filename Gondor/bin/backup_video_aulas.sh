#!/bin/bash

EXCLUDE_LIST="/ArquivosLinux/OneDrive/Backups/Gondor/excludes/exclude-gondor.list"

LOCAL_SOURCE="/home/jfreitas/Vídeos/Algebra_1"

LOCAL_BACKUP="/ArquivosLinux/OneDrive/UnB/Disciplinas/Graduacao/videos_aulas/"

rsync -avzzc --exclude-from=$EXCLUDE_LIST $LOCAL_SOURCE $LOCAL_BACKUP