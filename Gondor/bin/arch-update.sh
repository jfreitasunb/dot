#!/usr/bin/env bash

echo 'Updating Applications...'
    sudo aura -Syu
    sudo aura -Ayu
    #paru -Syyu
#
echo ' '
echo 'Cleaning caches & directories...'
#   sudo pacman -Sc
   sudo aura -Sc

   cd /home/jfreitas/.cache/paru/clone/
   rm -rf *
echo ' '

#xmonad --recompile

echo 'Updating Complete!'
