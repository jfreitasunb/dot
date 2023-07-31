#!/bin/bash

EXCLUDE_LIST_TEX="/Arquivos/Dropbox/Backups/Debian/excludes/exclude-TEX.list"

EXCLUDE_LIST_LARAVEL="/Arquivos/Dropbox/Backups/Debian/excludes/exclude-GitHub_laravel.list"

ALGEBRA1="/home/jfreitas/GitHub/Algebra-1/"
DEST_ALGEBRA1="/Arquivos/Dropbox/UnB/Disciplinas/Graduacao/Algebra_1/2022-2"

IAL="/home/jfreitas/GitHub/IAL/"
DEST_IAL="/Arquivos/Dropbox/UnB/Disciplinas/Graduacao/IAL/2023-2"

AULASONLINE="/home/jfreitas/GitHub/video_aulas/"
DEST_AULASONLINE="/Arquivos/Dropbox/UnB/Disciplinas/Graduacao/pdf_video_aulas"

#ALGEBRA_LINEAR="/home/jfreitas/GitHub/algebra_linear/"
#DEST_ALGEBRA_LINEAR="/Arquivos/Dropbox/UnB/Disciplinas/Graduacao/Algebra_Linear/2019-1"

#CAT="/home/jfreitas/GitHub/cat/"
#DEST_CAT="/Arquivos/Dropbox/UnB/CAT"

#MONITORIAMAT="/home/jfreitas/GitHub/inscricoesmonitoria/"
#DEST_MONITORIAMAT="/Arquivos/Dropbox/UnB/Projetos-PHP/inscricoesmonitoria"

POSMAT="/home/jfreitas/GitHub/inscricoespos/"
DEST_POSMAT="/Arquivos/Dropbox/UnB/Projetos-PHP/inscricoespos"

#INSCRICOESPNPD="/home/jfreitas/GitHub/inscricoespnpd/"
#DEST_INSCRICOESPNPD="/Arquivos/Dropbox/UnB/Projetos-PHP/inscricoespnpd"

#PROFICIENCIA="/home/jfreitas/GitHub/proficiencia/"
#DEST_PROFICIENCIA="/Arquivos/Dropbox/UnB/Projetos-PHP/proficiencia"

#SITEMONITORIAMAT="/home/jfreitas/GitHub/site-monitoriamat/"
#DEST_SITEMONITORIAMAT="/Arquivos/Dropbox/UnB/Projetos-PHP/site-monitoriamat"

#INSCRICOESVERAO="/home/jfreitas/GitHub/inscricoesverao/"
#DEST_INSCRICOESVERAO="/Arquivos/Dropbox/UnB/Projetos-PHP/inscricoesverao"

#INSCRICOESEVENTOSMAT="/home/jfreitas/GitHub/inscricoeseventos/"
#DEST_INSCRICOESEVENTOSMAT="/Arquivos/Dropbox/UnB/Projetos-PHP/inscricoeseventos"

rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$ALGEBRA1" "$DEST_ALGEBRA1"

rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$IAL" "$DEST_IAL"

rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" "$AULASONLINE" "$DEST_AULASONLINE"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_TEX" $ALGEBRA_LINEAR $DEST_ALGEBRA_LINEAR

#rsync -avzz "$CAT" "$DEST_CAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$MONITORIAMAT" "$DEST_MONITORIAMAT"

rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$POSMAT" "$DEST_POSMAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$PROFICIENCIA" "$DEST_PROFICIENCIA"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$SITEMONITORIAMAT" "$DEST_SITEMONITORIAMAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$INSCRICOESVERAO" "$DEST_INSCRICOESVERAO"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$INSCRICOESEVENTOSMAT" "$DEST_INSCRICOESEVENTOSMAT"

#rsync -avzz --exclude-from="$EXCLUDE_LIST_LARAVEL" "$INSCRICOESPNPD" "$DEST_INSCRICOESPNPD"
