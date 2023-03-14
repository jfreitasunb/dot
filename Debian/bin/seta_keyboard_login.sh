#!/usr/bin/bash

if [ "$(lsusb | grep -c '045e:0745')" -ge 1 ]; then
    setxkbmap -model abnt2 -layout br -variant abnt2
else
   setxkbmap -layout us -variant intl 
fi
