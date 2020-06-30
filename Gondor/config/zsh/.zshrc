# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
bindkey -e
setopt hist_ignore_all_dups
setopt hist_ignore_space

PATH=$PATH:$HOME/.bin
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
alias vul='vagrant up laravel'
alias vud='vagrant halt laravel'
alias vsl='vagrant ssh laravel'
alias avell='teclado_avell.sh'

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
