#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# source .bashrc modules
source ./.bash_aliases
source ./.bash_functions


# if powerline-daemon exists 
# and current terminal is not nvim terminal
# and there is X server session
if [ -f $(which powerline-daemon) ] && [ -z $MYVIMRC ] && [[ $DISPLAY ]]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/share/powerline/bindings/bash/powerline.sh
fi
