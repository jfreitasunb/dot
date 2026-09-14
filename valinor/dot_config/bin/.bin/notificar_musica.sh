#!/bin/bash

# Executa o bloco de código toda vez que o player mudar de faixa
playerctl --player=spotify metadata --format "{{ artist }} - {{ title }}" --follow | while read -r musica; do

    # Se a música não estiver vazia, envia a notificação
    if [ ! -z "$musica" ]; then
        # Pega o nome do álbum para usar de detalhe opcional
        album=$(playerctl --player=spotify metadata album)

        # Envia a notificação com ícone de música
        notify-send -i multimedia-audio-player "Tocando agora:" "$musica\nÁlbum: $album"
    fi
done
