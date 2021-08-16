#!/usr/bin/bash -x
sed -n '/START_KEYS/,/END_KEYS/p' ~/.xmonad/xmonad.hs | grep -e ', ("' -e '\[ (' | grep -v '\-\- , ("'
