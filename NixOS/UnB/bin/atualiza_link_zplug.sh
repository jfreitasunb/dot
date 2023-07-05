#!/usr/bin/env bash

unlink ~/.init.zsh

ln -s /nix/store/$(ls /nix/store | grep zplug | awk '$0 !~/drv/')/share/zplug/init.zsh ~/.init.zsh
