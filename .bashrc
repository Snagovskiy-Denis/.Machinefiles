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

# less colors
export LESS='-R --use-color -Dd+r$Du+b'

# powerline. pkgs: `sudo pacman -S powerline powerline-fonts`
if [ -f $(which powerline-daemon) ] && [ -z $MYVIMRC ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/share/powerline/bindings/bash/powerline.sh
fi

# git autocompleion
source ~/.config/.git-completion.bash

# aliases 
alias ls='ls --color=auto'
alias py='ipython'
alias cb='xsel -b'  # copy to clipboard or print cb
alias ti='tilda -g ~/.config/tilda/config_0'
alias r='ranger'

## vi
alias :q='exit'
alias :Q='exit'

## advanced
alias cr='cmus-remote'  # c music player
alias tt='taskwarrior-tui'

## dev
alias ut='python -m unittest'
alias ft='python -m unittest test/functional_tests/*.py'
alias TODO="grep TODO . -Rn --exclude-dir=lib* --exclude-dir=htmlcov --color=always | sed -r 's/(\:.*\:).*\#/\1/'"

# functions
note () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
        # clear file
        printf "%s" > "$HOME/.notes"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}
