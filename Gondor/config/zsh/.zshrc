neofetch

export STARSHIP_CONFIG=~/.config/starship/starship.toml

bindkey -e

PATH=$PATH:$HOME/.bin
PATH="HOME/.cargo/bin:$PATH"

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

eval $(keychain --eval ~/.ssh/id_rsa)
eval $(keychain --eval ~/.ssh/id_ecdsa)

# navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

source ~/.config/aliases/aliases
