#!/bin/bash

data_hoje=$(date +%d-%m-%Y_%H:%m:%S)

konsave -s backup_$data_hoje

cp -R ~/.config/konsave /home/jfreitas/GitHub/dot/Manjaro/KDE-configs/

cd /home/jfreitas/GitHub/dot/Manjaro/KDE-configs/

git add .

git commit -m "Ajustes nas configurações do KDE feitas no dia "$data_hoje
