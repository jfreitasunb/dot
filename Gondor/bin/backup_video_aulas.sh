#!/bin/bash
LOCAL_SOURCE="/home/jfreitas/Vídeos/Algebra_1"

LOCAL_BACKUP="/ArquivosLinux/OneDrive/UnB/Disciplinas/Graduacao/arquivos_das_videos_aulas/"

rsync -avzzc "$LOCAL_SOURCE" "$LOCAL_BACKUP"