ZDOTDIR=$HOME/.config/zsh

if [ -d "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi

export EDITOR="nvim"
export VISUAL="nvim"

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

### ---- history config -------------------------------------
HISTFILE=~/.zsh_history

# How many commands zsh will load to memory.
HISTSIZE=10000

# How maney commands history will save on file.
SAVEHIST=1000000000

# History won't save duplicates.
setopt HIST_SAVE_NO_DUPS

# History won't show duplicates on search.
#setopt HIST_FIND_NO_DUPS
#if [ -d "/usr/local/texlive/2023/bin/x86_64-linux" ] ; then
#    PATH="/usr/local/texlive/2023/bin/x86_64-linux:$PATH"
#fi

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cabal/bin" ] ; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

if [ -d "$HOME/.local/go/bin" ] ; then
    PATH="$HOME/.local/go/bin:$PATH"
fi

if [ -d "$HOME/.local/kitty.app/bin" ] ; then
    PATH="$HOME/.local/kitty.app/bin:$PATH"
fi

export PATH

bindkey -e

# Use modern completion system
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
_comp_options+=(globdots) # With hidden files

# zplug - manage plugins
source /usr/share/zsh/scripts/zplug/init.zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "junegunn/fzf"
#zplug "romkatv/powerlevel10k", as:theme, depth:1

# zplug - install/load new plugins when zsh is started or reloaded
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

#bindkey '^[[OA' history-substring-search-up
#bindkey '^[[OB' history-substring-search-down

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

source ~/.config/aliases

if [ -d "$HOME/.pyenv" ] ; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

#source ~/.config/zsh/.p10k.zsh

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#neofetch

eval "$(starship init zsh)"
#. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
eval "$(pyenv virtualenv-init -)"

#Configuração para o Yazi.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
