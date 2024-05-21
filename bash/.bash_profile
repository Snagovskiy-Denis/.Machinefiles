#!/usr/bin/env bash

# Adds ~/.local/bin and its subdirectories to $PATH
append_executables="$(find "${HOME}/.local/bin" -not -path '*/__pycache__' -type d -printf :%p)"
export PATH="${PATH}$append_executables"
export PYTHONPATH="${PYTHONPATH}$append_executables"

# Default programs
export TERMINAL=alacritty
export EDITOR=nvim
export BROWSER=vivaldi-stable

# XDG Base Directories:
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
user_dirs="${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" 
test -r "${user_dirs}" && . "${user_dirs}"

# ~/ Clean-up:
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME:-$HOME/.config}/java"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
export TASKRC="${XDG_CONFIG_HOME:-$HOME/.config}/taskrc"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wgetrc"
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/X11/xinitrc"
export STACK_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/stack"
export DOCKER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/docker"
export POETRY_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/poetry"
export GRADLE_USER_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gradle"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pass"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
alias yarn="yarn --use-yarnrc ${XDG_CONFIG_HOME:-$HOME/.config}/yarn/config"
alias irssi="irssi --config=${XDG_CONFIG_HOME:-$HOME/.config}/irssi/config --home=${XDG_DATA_HOME}/irssi"
alias wget="wget --hsts-file=${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts"

# User directories
export ZETTELKASTEN="${HOME}/Vaults/Zettelkasten/Z/"
export ZETTELKASTEN_DB="${ZETTELKASTEN}../db.sqlite3"

export USER_ICONS="${XDG_DATA_HOME}/icons/self/"
export USER_BKP="${HOME}/.local/bkp/"

# Other program settings:
export LESS='-R --use-color -Dd+r$Du+b'
export PYTHONBREAKPOINT=ipdb.set_trace  # python breakpoint() calls ipdb now

export LEDGER_FILE="${ZETTELKASTEN}../me.ldg"
alias newsboat="newsboat --url-file=${ZETTELKASTEN}../newsboat_rss_feed_urls.txt"


autocompletions=(
    /usr/share/bash-completion/bash_completion
    "${XDG_CONFIG_HOME:-$HOME/.config}/.git_completion.bash"
    "${XDG_CONFIG_HOME:-$HOME/.config}/bash_task_completion.bash"
)
for autocompletion in "${autocompletions[@]}"
do
    test -r "$autocompletion" && . "$autocompletion"
done


test -r ~/.bashrc && . ~/.bashrc


# x session
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx "${XINITRC}"
fi

# without x session
${HOME}/.config/shell/keyboard.sh
