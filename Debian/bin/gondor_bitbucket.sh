#!/bin/bash

EXCLUDE_LIST_TEX="/Arquivos/OneDriveUnB/Backups/Debian/excludes/exclude-TEX.list"

EXCLUDE_LIST_LARAVEL="/Arquivos/OneDriveUnB/Backups/Debian/excludes/exclude-GitHub_laravel.list"

ALGEBRA1="/home/jfreitas/GitHub/Algebra-1/"
DEST_ALGEBRA1="/Arquivos/OneDriveUnB/UnB/Disciplinas/Graduacao/Algebra_1/2024-1"

#IAL="/home/jfreitas/GitHub/IAL/"
#DEST_IAL="/Arquivos/OneDriveUnB/UnB/Disciplinas/Graduacao/IAL/2023-2"

#AULASONLINE="/home/jfreitas/GitHub/video_aulas/"
#DEST_AULASONLINE="/Arquivos/OneDriveUnB/UnB/Disciplinas/Graduacao/pdf_video_aulas"

#ALGEBRA_LINEAR="/home/jfreitas/GitHub/algebra_linear/"
#DEST_ALGEBRA_LINEAR="/Arquivos/OneDriveUnB/UnB/Disciplinas/Graduacao/Algebra_Linear/2019-1"

#CAT="/home/jfreitas/GitHub/cat/"
#DEST_CAT="/Arquivos/OneDriveUnB/UnB/CAT"

#MONITORIAMAT="/home/jfreitas/GitHub/inscricoesmonitoria/"
#DEST_MONITORIAMAT="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/inscricoesmonitoria"

#INSCRICOESPOSMAT="/home/jfreitas/GitHub/inscricoespos/"                  
#DEST_INSCRICOESPOSMAT="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/inscricoespos"

#POSMAT="/home/jfreitas/GitHub/inscricoespos/"
#DEST_POSMAT="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/inscricoespos"

#INSCRICOESPNPD="/home/jfreitas/GitHub/inscricoespnpd/"
#DEST_INSCRICOESPNPD="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/inscricoespnpd"

#PROFICIENCIA="/home/jfreitas/GitHub/proficiencia/"
#DEST_PROFICIENCIA="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/proficiencia"

#SITEMONITORIAMAT="/home/jfreitas/GitHub/site-monitoriamat/"
#DEST_SITEMONITORIAMAT="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/site-monitoriamat"

#INSCRICOESVERAO="/home/jfreitas/GitHub/inscricoesverao/"
#DEST_INSCRICOESVERAO="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/inscricoesverao"

#INSCRICOESEVENTOSMAT="/home/jfreitas/GitHub/inscricoeseventos/"
#DEST_INSCRICOESEVENTOSMAT="/Arquivos/OneDriveUnB/UnB/Projetos-PHP/inscricoeseventos"

rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$ALGEBRA1" "$DEST_ALGEBRA1"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$IAL" "$DEST_IAL"

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
