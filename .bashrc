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
if [ -f $(which powerline-daemon) ] && [ -z $MYVIMRC ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/share/powerline/bindings/bash/powerline.sh
fi

# git autocompleion
source ~/.config/.git-completion.bash


# messing with stuff
#todo () {
    #max_width=0
    #while read -r line ; do
        #line_width=$(echo $line | wc -c)
        #if [ $line_width -gt $max_width ]; then
            #max_width=$line_width
        #fi
    #done < <(grep TODO . -Rn --exclude-dir=venv --color=always)

    ## I knows that this is dumb..
    #while read -r line ; do
        #line_width=$(echo $line | wc -c)
        #num_of_spaces=$(expr $max_width - $line_width)
        #echo $num_of_spaces
        #sed $line -r 's/(\:.*\:)(.*)\#/\1/'
    #done < <(grep TODO . -Rn --exclude-dir=venv --color=always)
#}

# aliases 
alias ls='ls --color=auto'
alias py='ipython'
alias cb='xsel -b'

alias cr='cmus-remote'  # c music player
alias tt='taskwarrior-tui'

## dev
alias ut='python -m unittest'
alias ft='python -m unittest test/functional_tests/*.py'
alias TODO="grep TODO . -Rn --exclude-dir=venv --exclude-dir=htmlcov --color=always | sed -r 's/(\:.*\:).*\#/\1/'"
