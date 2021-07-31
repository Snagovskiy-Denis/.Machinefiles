#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# environment variables
export TERMINAL=alacritty
export VISUAL=nvim
export EDITOR="$VISUAL"

export PATH=$PATH:/home/self/Code/executable


# git autocompleion
source ~/.config/.git-completion.bash


# less colors
export LESS='-R --use-color -Dd+r$Du+b'


# x session
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi
