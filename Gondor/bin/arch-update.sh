#!/usr/bin/env bash

echo 'Updating Applications...'
    sudo pacman -Syyu
    paru -Syyu

echo ' '
echo 'Cleaning caches & directories...'
   sudo pacman -Sc
   paru -Sc

   cd /home/jfreitas/.cache/paru/clone/
   rm -rf *
echo ' '

#xmonad --recompile

echo 'Updating Complete!'
