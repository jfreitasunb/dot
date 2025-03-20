#!/bin/bash

EXCLUDE_LIST_TEX="/home/jfreitas/OneDriveUnB/Backups/Debian/excludes/exclude-TEX.list"

EXCLUDE_LIST_LARAVEL="/home/jfreitas/OneDriveUnB/Backups/Debian/excludes/exclude-GitHub_laravel.list"

ALGEBRA1="/home/jfreitas/GitHub/Algebra-1/"
DEST_ALGEBRA1="/home/jfreitas/OneDriveUnB/UnB/Disciplinas/Graduacao/Algebra_1/2024-1"

#IAL="/home/jfreitas/GitHub/IAL/"
#DEST_IAL="/home/jfreitas/OneDriveUnB/UnB/Disciplinas/Graduacao/IAL/2023-2"

#AULASONLINE="/home/jfreitas/GitHub/video_aulas/"
#DEST_AULASONLINE="/home/jfreitas/OneDriveUnB/UnB/Disciplinas/Graduacao/pdf_video_aulas"

#ALGEBRA_LINEAR="/home/jfreitas/GitHub/algebra_linear/"
#DEST_ALGEBRA_LINEAR="/home/jfreitas/OneDriveUnB/UnB/Disciplinas/Graduacao/Algebra_Linear/2019-1"

#CAT="/home/jfreitas/GitHub/cat/"
#DEST_CAT="/home/jfreitas/OneDriveUnB/UnB/CAT"

#MONITORIAMAT="/home/jfreitas/GitHub/inscricoesmonitoria/"
#DEST_MONITORIAMAT="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/inscricoesmonitoria"

#INSCRICOESPOSMAT="/home/jfreitas/GitHub/inscricoespos/"                  
#DEST_INSCRICOESPOSMAT="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/inscricoespos"

#POSMAT="/home/jfreitas/GitHub/inscricoespos/"
#DEST_POSMAT="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/inscricoespos"

#INSCRICOESPNPD="/home/jfreitas/GitHub/inscricoespnpd/"
#DEST_INSCRICOESPNPD="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/inscricoespnpd"

#PROFICIENCIA="/home/jfreitas/GitHub/proficiencia/"
#DEST_PROFICIENCIA="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/proficiencia"

#SITEMONITORIAMAT="/home/jfreitas/GitHub/site-monitoriamat/"
#DEST_SITEMONITORIAMAT="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/site-monitoriamat"

#INSCRICOESVERAO="/home/jfreitas/GitHub/inscricoesverao/"
#DEST_INSCRICOESVERAO="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/inscricoesverao"

#INSCRICOESEVENTOSMAT="/home/jfreitas/GitHub/inscricoeseventos/"
#DEST_INSCRICOESEVENTOSMAT="/home/jfreitas/OneDriveUnB/UnB/Projetos-PHP/inscricoeseventos"

rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$ALGEBRA1" "$DEST_ALGEBRA1"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$IAL" "$DEST_IAL"

rsync -avzz "$CODIGOSR" "$DEST_CODIGOSR"
#rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$AULASONLINE" "$DEST_AULASONLINE"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" $ALGEBRA_LINEAR $DEST_ALGEBRA_LINEAR

#rsync -avzz "$CAT" "$DEST_CAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$MONITORIAMAT" "$DEST_MONITORIAMAT"

rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$INSCRICOESPOSMAT" "$DEST_INSCRICOESPOSMAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$POSMAT" "$DEST_POSMAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$PROFICIENCIA" "$DEST_PROFICIENCIA"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$SITEMONITORIAMAT" "$DEST_SITEMONITORIAMAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$INSCRICOESVERAO" "$DEST_INSCRICOESVERAO"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$INSCRICOESEVENTOSMAT" "$DEST_INSCRICOESEVENTOSMAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$INSCRICOESPNPD" "$DEST_INSCRICOESPNPD"
