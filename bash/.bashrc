#!/usr/bin/env bash


# If not running interactively, don't do anything
[[ $- != *i* ]] && return


scripts=(
    "${XDG_CONFIG_HOME}/shell/functions" 
    "${XDG_CONFIG_HOME}/shell/aliases" 
)
for script in "${scripts[@]}"
do
    test -r "$script" && . "$script"
done

# if test -d /etc/profile.d/; then
# 	for profile in /etc/profile.d/*.sh; do
# 		test -r "$profile" && . "$profile"
# 	done
# 	unset profile
# fi

# Auto "cd" when entering just a path
shopt -s autocd


# ./.bash_history
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE="${XDG_DATA_HOME:-${HOME}/.local/share}/bash_eternal_history"
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"


ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}


# setups zoxide https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file
eval "$(zoxide init bash)"

# fzf - https://wiki.archlinux.org/title/Fzf
eval "$(fzf --bash)"

# force fzf to respect .gitignore's and .fdignore's
export FZF_DEFAULT_COMMAND='fd --type f'


# if powerline-daemon exists 
# and current terminal is not nvim terminal
# and there is X server session
if [ -f $(which powerline-daemon) ] && [ -z "${MYVIMRC}" ] && [[ "${DISPLAY}" ]]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source "/usr/share/powerline/bindings/bash/powerline.sh"
fi

alias sf='setfont /usr/share/kbd/consolefonts/cyr-sun16.psfu.gz -d'

# appended by other apps
