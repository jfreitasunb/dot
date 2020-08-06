#!/bin/bash

EXCLUDE_LIST_TEX="/Arquivos/OneDrive\ -\ unb.br/Backups/Gondor/excludes/exclude-TEX.list"

EXCLUDE_LIST_LARAVEL="/Arquivos/OneDrive\ -\ unb.br/Backups/Gondor/excludes/exclude-GitHub_Repos_laravel.list"

ALGEBRA1="/home/jfreitas/GitHub_Repos/algebra1/"
DEST_ALGEBRA1="/Arquivos/OneDrive\ -\ unb.br/UnB/Disciplinas/Graduacao/Algebra_1/2020-1"

AULASONLINE="/home/jfreitas/GitHub_Repos/video_aulas/"
DEST_AULASONLINE="/Arquivos/OneDrive\ -\ unb.br/UnB/Disciplinas/Graduacao/pdf_video_aulas"

#ALGEBRA_LINEAR="/home/jfreitas/GitHub_Repos/algebra_linear/"
#DEST_ALGEBRA_LINEAR="/Arquivos/OneDrive\ -\ unb.br/UnB/Disciplinas/Graduacao/Algebra_Linear/2019-1"

CAT="/home/jfreitas/GitHub_Repos/cat/"
DEST_CAT="/Arquivos/OneDrive\ -\ unb.br/UnB/CAT"

MONITORIAMAT="/home/jfreitas/GitHub_Repos/inscricoesmonitoria/"
DEST_MONITORIAMAT="/Arquivos/OneDrive\ -\ unb.br/UnB/Projetos-PHP/inscricoesmonitoria"

POSMAT="/home/jfreitas/GitHub_Repos/inscricoespos/"
DEST_POSMAT="/Arquivos/OneDrive\ -\ unb.br/UnB/Projetos-PHP/inscricoespos"

INSCRICOESPNPD="/home/jfreitas/GitHub_Repos/inscricoespnpd/"
DEST_INSCRICOESPNPD="/Arquivos/OneDrive\ -\ unb.br/UnB/Projetos-PHP/inscricoespnpd"

PROFICIENCIA="/home/jfreitas/GitHub_Repos/proficiencia/"
DEST_PROFICIENCIA="/Arquivos/OneDrive\ -\ unb.br/UnB/Projetos-PHP/proficiencia"

SITEMONITORIAMAT="/home/jfreitas/GitHub_Repos/site-monitoriamat/"
DEST_SITEMONITORIAMAT="/Arquivos/OneDrive\ -\ unb.br/UnB/Projetos-PHP/site-monitoriamat"

INSCRICOESVERAO="/home/jfreitas/GitHub_Repos/inscricoesverao/"
DEST_INSCRICOESVERAO="/Arquivos/OneDrive\ -\ unb.br/UnB/Projetos-PHP/inscricoesverao"

INSCRICOESEVENTOSMAT="/home/jfreitas/GitHub_Repos/inscricoeseventos/"
DEST_INSCRICOESEVENTOSMAT="/Arquivos/OneDrive\ -\ unb.br/UnB/Projetos-PHP/inscricoeseventos"

rsync -avzz --exclude-from=$EXCLUDE_LIST_TEX $ALGEBRA1 $DEST_ALGEBRA1

rsync -avzz --exclude-from=$EXCLUDE_LIST_TEX $AULASONLINE $DEST_AULASONLINE

#rsync -avzz --exclude-from=$EXCLUDE_LIST_TEX $ALGEBRA_LINEAR $DEST_ALGEBRA_LINEAR

rsync -avzz $CAT $DEST_CAT

rsync -avzz --exclude-from=$EXCLUDE_LIST_LARAVEL $MONITORIAMAT $DEST_MONITORIAMAT

rsync -avzz --exclude-from=$EXCLUDE_LIST_LARAVEL $POSMAT $DEST_POSMAT

rsync -avzz --exclude-from=$EXCLUDE_LIST_LARAVEL $PROFICIENCIA $DEST_PROFICIENCIA

rsync -avzz --exclude-from=$EXCLUDE_LIST_LARAVEL $SITEMONITORIAMAT $DEST_SITEMONITORIAMAT

rsync -avzz --exclude-from=$EXCLUDE_LIST_LARAVEL $INSCRICOESVERAO $DEST_INSCRICOESVERAO

rsync -avzz --exclude-from=$EXCLUDE_LIST_LARAVEL $INSCRICOESEVENTOSMAT $DEST_INSCRICOESEVENTOSMAT

rsync -avzz --exclude-from=$EXCLUDE_LIST_LARAVEL $INSCRICOESPNPD $DEST_INSCRICOESPNPD