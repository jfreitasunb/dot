# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export VISUAL=vim
export EDITOR=vim
neofetch
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
bindkey -e
setopt hist_ignore_all_dups
setopt hist_ignore_space

PATH=$PATH:$HOME/.bin
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

alias aup='arch-update.sh'
alias pac='sudo pacman'
alias riv='cd /ArquivosLinux/Dropbox/php/vagrant/rivendel'
alias vul='vagrant up laravel && vagrant rsync-auto'
alias vud='vagrant halt laravel'
alias vsl='vagrant ssh laravel'
alias avell='teclado_avell.sh'
alias tsm='transmission-remote'
alias wtsm='watch transmission-remote -l'


eval $(keychain --eval ~/.ssh/id*)

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --group-directories-first' # tree listing
alias lr='exa --color=always --sort newest --group-directories-first' # tree listing
alias wtsm='watch transmission-remote -l'
# Changing "cat" to "bat"
alias cat='bat'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/GitHub_Repos/dot/Gondor/config/zsh/.p10k.zsh.
[[ ! -f ~/GitHub_Repos/dot/Gondor/config/zsh/.p10k.zsh ]] || source ~/GitHub_Repos/dot/Gondor/config/zsh/.p10k.zsh
