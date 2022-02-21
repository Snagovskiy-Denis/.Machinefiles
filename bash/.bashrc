#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# load aliases and functions if existent
functions_filepath="${HOME}/.config/shell/functions" 
aliases_filepath="${HOME}/.config/shell/aliases" 
[ -f ${functions_filepath} ] && source ${functions_filepath}
[ -f ${aliases_filepath}   ] && source ${aliases_filepath}

# autojump - https://wiki.archlinux.org/title/Autojump
autojump_filepath=/etc/profile.d/autojump.sh
[[ -s ${autojump_filepath} ]] && source ${autojump_filepath}

# fzf - https://wiki.archlinux.org/title/Fzf
fzf_key_bindings_filepath=/usr/share/fzf/key-bindings.bash
fzf_completion_filepath=/usr/share/fzf/completion.bash
[[ -f ${fzf_key_bindings_filepath} ]] && source ${fzf_key_bindings_filepath}
[[ -f ${fzf_completion_filepath} ]] && source ${fzf_completion_filepath}

# Auto "cd" when entering just a path
shopt -s autocd


# Fix if run from terminal https://github.com/qtile/qtile/issues/2167
#export -n LINES
#export -n COLUMNS


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


# if powerline-daemon exists 
# and current terminal is not nvim terminal
# and there is X server session
if [ -f $(which powerline-daemon) ] && [ -z "${MYVIMRC}" ] && [[ "${DISPLAY}" ]]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source "/usr/share/powerline/bindings/bash/powerline.sh"
fi
