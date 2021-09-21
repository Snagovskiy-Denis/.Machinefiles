#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Adds ~/.local/bin and its subdirectories to $PATH
export PATH="${PATH}$(find "${HOME}/.local/bin" -type d -printf :%p)"

# Default programs
export TERMINAL=alacritty
export EDITOR=nvim
export BROWSER=vivaldi-stable

# XDG Base Directories:
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
user_dirs="$XDG_CONFIG_HOME/user-dirs.dirs" 
[[ -f "${user_dirs}" ]] && source "${user_dirs}"

# ~/ Clean-up:
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export TASKRC="${XDG_CONFIG_HOME}/taskrc"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"

# Other program settings:
export LESS='-R --use-color -Dd+r$Du+b'

# Autocompletion
source ~/.config/.git-completion.bash

# x session
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx "${XINITRC}"
fi

# without x session
${HOME}/.config/shell/keyboard.sh
