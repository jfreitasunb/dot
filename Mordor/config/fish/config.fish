### EXPORT ###
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $HOME/Applications $fish_user_paths
set fish_greeting                      # Supresses fish's intro message
set TERM "xterm-256color"              # Sets the terminal type
set EDITOR "nvim"      # $EDITOR use Emacs in terminal

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias lr='exa --sort newest --color=always --group-directories-first' # tree listing
alias wtsm='watch transmission-remote -l'
# Changing "cat" to "bat"

### "bat" as manpager
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
  # fish_default_key_bindings
  fish_vi_key_bindings
end
### END OF VI MODE ###

#Mais alguns alias personalizados
alias aup='arch-update.sh'
alias avell='teclado_avell.sh'

#eval $(keychain --eval ~/.ssh/id_rsa)
#eval $(keychain --eval ~/.ssh/id_ecdsa)

if status is-interactive
    # Commands to run in interactive sessions can go here
end

neofetch
