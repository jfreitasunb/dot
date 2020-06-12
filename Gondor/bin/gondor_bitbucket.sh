#!/bin/bash

EXCLUDE_LIST_TEX="/ArquivosLinux/Dropbox/Backups/Gondor/excludes/exclude-TEX.list"

EXCLUDE_LIST_LARAVEL="/ArquivosLinux/Dropbox/Backups/Gondor/excludes/exclude-bitbucket_laravel.list"

ALGEBRA1="/home/jfreitas/Bitbucket/algebra1/"
DEST_ALGEBRA1="/ArquivosLinux/Dropbox/UnB/Disciplinas/Graduacao/Algebra_1/2020-1"

AULASONLINE="/home/jfreitas/Bitbucket/video_aulas"
AULASONLINE="/ArquivosLinux/Dropbox/UnB/Disciplinas/Graduacao/video_aulas"

#ALGEBRA_LINEAR="/home/jfreitas/Bitbucket/algebra_linear/"
#DEST_ALGEBRA_LINEAR="/ArquivosLinux/Dropbox/UnB/Disciplinas/Graduacao/Algebra_Linear/2019-1"

CAT="/home/jfreitas/Bitbucket/cat/"
DEST_CAT="/ArquivosLinux/Dropbox/UnB/CAT"

MONITORIAMAT="/home/jfreitas/Bitbucket/inscricoesmonitoria/"
DEST_MONITORIAMAT="/ArquivosLinux/Dropbox/UnB/Projetos-PHP/inscricoesmonitoria"

POSMAT="/home/jfreitas/Bitbucket/inscricoespos/"
DEST_POSMAT="/ArquivosLinux/Dropbox/UnB/Projetos-PHP/inscricoespos"

INSCRICOESPNPD="/home/jfreitas/Bitbucket/inscricoespnpd/"
DEST_INSCRICOESPNPD="/ArquivosLinux/Dropbox/UnB/Projetos-PHP/inscricoespnpd"

PROFICIENCIA="/home/jfreitas/Bitbucket/proficiencia/"
DEST_PROFICIENCIA="/ArquivosLinux/Dropbox/UnB/Projetos-PHP/proficiencia"

SITEMONITORIAMAT="/home/jfreitas/Bitbucket/site-monitoriamat/"
DEST_SITEMONITORIAMAT="/ArquivosLinux/Dropbox/UnB/Projetos-PHP/site-monitoriamat"

INSCRICOESVERAO="/home/jfreitas/Bitbucket/inscricoesverao/"
DEST_INSCRICOESVERAO="/ArquivosLinux/Dropbox/UnB/Projetos-PHP/inscricoesverao"

INSCRICOESEVENTOSMAT="/home/jfreitas/Bitbucket/inscricoeseventos/"
DEST_INSCRICOESEVENTOSMAT="/ArquivosLinux/Dropbox/UnB/Projetos-PHP/inscricoeseventos"

rsync -avz --exclude-from=$EXCLUDE_LIST_TEX $ALGEBRA1 $DEST_ALGEBRA1

rsync -avz --exclude-from=$EXCLUDE_LIST_TEX $AULASONLINE $DEST_ALGEBRA1

#rsync -avz --exclude-from=$EXCLUDE_LIST_TEX $ALGEBRA_LINEAR $DEST_ALGEBRA_LINEAR

rsync -avz $CAT $DEST_CAT

rsync -avz --exclude-from=$EXCLUDE_LIST_LARAVEL $MONITORIAMAT $DEST_MONITORIAMAT

rsync -avz --exclude-from=$EXCLUDE_LIST_LARAVEL $POSMAT $DEST_POSMAT

rsync -avz --exclude-from=$EXCLUDE_LIST_LARAVEL $PROFICIENCIA $DEST_PROFICIENCIA

rsync -avz --exclude-from=$EXCLUDE_LIST_LARAVEL $SITEMONITORIAMAT $DEST_SITEMONITORIAMAT

rsync -avz --exclude-from=$EXCLUDE_LIST_LARAVEL $INSCRICOESVERAO $DEST_INSCRICOESVERAO

rsync -avz --exclude-from=$EXCLUDE_LIST_LARAVEL $INSCRICOESEVENTOSMAT $DEST_INSCRICOESEVENTOSMAT

rsync -avz --exclude-from=$EXCLUDE_LIST_LARAVEL $INSCRICOESPNPD $DEST_INSCRICOESPNPD
