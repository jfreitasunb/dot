neofetch

bindkey -e

bindkey '^[[H' beginning-of-line     # Home
bindkey '^[[F' end-of-line     # End
bindkey '^[[3~' delete-char     # Delete
bindkey '^?' backward-delete-char     # Backspace

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
_comp_options+=(globdots) # With hidden files

### --- Spaceship Config ------------------------------------

source $ZDOTDIR/themes/spaceship-prompt/spaceship.zsh-theme

SPACESHIP_PROMPT_ORDER=(
   user          # Username section
   dir           # Current directory section
   host          # Hostname section
   git           # Git section (git_branch + git_status)
   hg            # Mercurial section (hg_branch  + hg_status)
   exec_time     # Execution time
   line_sep      # Line break
   vi_mode       # Vi-mode indicator
   jobs          # Background jobs indicator
   exit_code     # Exit code section
   char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "


### ---- PLUGINS & THEMES -----------------------------------
source $ZDOTDIR/themes/spaceship-prompt/spaceship.zsh-theme
#source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source $ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/Applications" ] ; then
    PATH="$HOME/Applications:$PATH"
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

# Backup a file with date
function backup() {
    cp "$1" "$1_`date +%Y-%m-%d_%H-%M-%S`_BACKUP"
}

# Update all git repos
function update_git_repos() {
  if [ $# -ne 1 ]; then
    echo "This function requires one parameter which must be a directory"
    return
  fi
  CURRENT_DIR=`pwd`
  echo "Updating all Git repos"
  for DIR in "$1"/*; do
    echo "\n========================================\n$DIR\n========================================"
    if [[ -d "$CURRENT_DIR/$DIR" ]]; then
      \cd "$CURRENT_DIR/$DIR"
      git status
      git pull origin $(git rev-parse --abbrev-ref HEAD)
    else
      echo "$CURRENT_DIR/$DIR not a directory"
    fi
  done
  \cd "$CURRENT_DIR"
}

source ~/.config/aliases/aliases

#eval "$(starship init zsh)"
