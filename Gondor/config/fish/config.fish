### EXPORT ###
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $fish_user_paths
set fish_greeting                      # Supresses fish's intro message
set TERM "xterm-256color"              # Sets the terminal type
set EDITOR "vim"      # $EDITOR use Emacs in terminal
#set VISUAL "emacsclient -c -a emacs"   # $VISUAL use Emacs in GUI mode

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

# Changing "cat" to "bat"
alias cat='bat'

#Mais alguns alias personalizados
alias aup='arch-update.sh'
alias avell='teclado_avell.sh'
neofetch
