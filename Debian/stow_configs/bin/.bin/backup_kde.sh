#!/bin/bash
source ~/.python_venv/konsave/bin/activate

data_hoje=`date '+%d-%m-%Y_%H:%M:%S'`

konsave -s backup_$data_hoje

cd ~/.config/konsave/profiles/

cp -R backup_$data_hoje/* /home/jfreitas/GitHub/dot/Debian/KDE-configs/

cd /home/jfreitas/GitHub/dot/Debian/KDE-configs/

git add .

git commit -m "Ajustes nas configurações do KDE feitas no dia "$data_hoje

deactivate
