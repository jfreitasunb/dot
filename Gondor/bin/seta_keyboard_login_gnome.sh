#!/usr/bin/bash


if [ "$(lsusb | grep -c '045e:0745')" -ge 1 ]; then
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'br')]"
else
   gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+alt-intl')]"
fi
