#!/bin/bash 

if [ "$(lsusb | grep -c '045e:0745')" -gt 0 ]; then
    setxkbmap -model abnt2 -layout br -variant abnt2
else
    setxkbmap -model abnt -layout br -variant thinkpad
fi