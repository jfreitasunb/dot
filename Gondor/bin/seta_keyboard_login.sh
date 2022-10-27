#!/usr/bin/bash

if [ "$(lsusb | grep -c '045e:0745')" -ge 1 ]; then
    echo "Teclado encontrado"
fi
