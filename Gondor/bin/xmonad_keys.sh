#!/usr/bin/bash -x
sed -n '/START_KEYS/,/END_KEYS/p' ~/.xmonad/xmonad.hs | \
    grep -e ', ("' \
    -e '\[ (' \
    -e 'KB_GROUPS' | \
    grep -v '\-\- , ("' | \
    sed -e 's/^[ \t]*//' \
        -e 's/, (/(/' \
        -e 's/\[ (/(/' \
        -e 's/-- KB_GROUPS /\n/' \
        -e 's/", /": /' | \
    yad --text-info --back=#282c34 --fore=#46d9ff --geometry=1200x800
