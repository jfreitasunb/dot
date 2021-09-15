#!/bin/bash
LOCAL_SOURCE="/home/jfreitas/Vídeos/Algebra_1"

LOCAL_BACKUP="/Arquivos/OneDrive/UnB/Disciplinas/Graduacao/arquivos_das_videos_aulas/"

rsync -avzzc --exclude /home/jfreitas/Vídeos/CacheClip/ "$LOCAL_SOURCE" "$LOCAL_BACKUP"