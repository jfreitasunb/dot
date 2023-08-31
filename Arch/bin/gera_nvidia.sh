#! /bin/bash

uname -a | grep -q lts

if [ $? -eq 0 ] ;
then 
  mkinitcpio -p linux-lts
else
  mkinitcpio -p linux
fi
