#!/usr/bin/env bash

echo 'Updating Applications...'
    sudo pacman -Syu
    paru -Syu

echo ' '
echo 'Cleaning caches & directories...'
    pacman -Sc
    paru -Sc

echo ' '

sudo rm /boot/grub/grub.cfg

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo 'Updating Complete!'