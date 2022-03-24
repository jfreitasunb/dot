# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export VISUAL=vim
export EDITOR=vim
neofetch
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
bindkey -e
setopt hist_ignore_all_dups
setopt hist_ignore_space

PATH=$PATH:$HOME/.bin
PATH="HOME/.cargo/bin:$PATH"

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# PATH=/home/jfreitas/.texlive/2020/bin/x86_64-linux:$PATH; export PATH
# MANPATH=/home/jfreitas/.texlive/2020/texmf-dist/doc/man:$MANPATH; export MANPATH
# INFOPATH=/home/jfreitas/.texlive/2020/texmf-dist/doc/info:$INFOPATH; export INFOPATH

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/jfreitas/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

eval $(keychain --eval ~/.ssh/id_rsa)
eval $(keychain --eval ~/.ssh/id_ecdsa)

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/GitHub_Repos/dot/Gondor/config/zsh/.p10k.zsh.
[[ ! -f ~/GitHub_Repos/dot/Gondor/config/zsh/.p10k.zsh ]] || source ~/GitHub_Repos/dot/Gondor/config/zsh/.p10k.zsh

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


### ALIASES #####
alias aup='arch-update.sh'
alias pac='sudo pacman'
alias riv='cd /ArquivosLinux/Dropbox/php/vagrant/rivendel'
alias vul='vagrant up laravel && vagrant rsync-auto'
alias vud='vagrant halt laravel'
alias vsl='vagrant ssh laravel'
alias avell='teclado_avell.sh'

# Changing "cat" to "bat"
alias cat='bat'

alias vim='nvim'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"


# Changing "ls" to "exa"
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --binary --color=always --group-directories-first'  # long format
alias lt='exa -aT --group-directories-first' # tree listing
alias lr='exa --color=always --sort newest --group-directories-first' # tree listing
alias ls='exa -la --binary --color=always --group-directories-first' # my preferred listing

