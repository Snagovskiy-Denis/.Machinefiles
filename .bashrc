#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# env variables
export VISUAL=nvim
export EDITOR="$VISUAL"
#PS1='[\u@\h \W]\$ '
export PATH=$PATH:/home/self/Code/executable

# powerline. pkgs: `sudo pacman -S powerline powerline-fonts`
if [ -f $(which powerline-daemon) ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/share/powerline/bindings/bash/powerline.sh
fi

# git autocompleion
source ~/.config/.git-completion.bash

# set vi-styled movement key bindings
set -o vi


# aliases 
alias ls='ls --color=auto'
alias py='ipython'
alias cb='xsel -b'

alias cr='cmus-remote'  # c music player
