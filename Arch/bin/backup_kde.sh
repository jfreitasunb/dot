#!/bin/bash -x

data_hoje=$(date +%d-%m-%Y_%H:%m:%S)

konsave -s backup_$data_hoje

cd ~/.config/konsave/profiles/

cp -R backup_$data_hoje/* /home/jfreitas/GitHub/dot/Arch/KDE-configs/

cd /home/jfreitas/GitHub/dot/Arch/KDE-configs/

git add .

git commit -m "Ajustes nas configurações do KDE feitas no dia "$data_hoje
