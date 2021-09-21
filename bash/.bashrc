#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# load aliases and functions if existent
[ -f "${HOME}/.config/shell/functions" ]&& source "${HOME}/.config/shell/functions"
[ -f "${HOME}/.config/shell/aliases" ]&& source "${HOME}/.config/shell/aliases"

# Auto "cd" when entering just a path
shopt -s autocd


# if powerline-daemon exists 
# and current terminal is not nvim terminal
# and there is X server session
if [ -f $(which powerline-daemon) ] && [ -z "${MYVIMRC}" ] && [[ "${DISPLAY}" ]]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source "/usr/share/powerline/bindings/bash/powerline.sh"
fi
