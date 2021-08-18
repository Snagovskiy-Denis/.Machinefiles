alias ls='ls --color=auto'

alias py='ipython'
alias r='ranger'
alias tt='taskwarrior-tui'
alias cr='cmus-remote'  # c music player

alias cb='xsel -b'  # copy to clipboard or print cb

# vi
alias :q='exit'
alias :Q='exit'

# dev
alias ut='python -m unittest'
alias ft='python -m unittest tests/functional_tests/*.py'
alias TODO="grep TODO . -Rn --exclude-dir=lib* --exclude-dir=htmlcov --color=always | sed -r 's/(\:.*\:).*\#/\1/'"

# ~/ Clean-up:
alias irssi="irssi --config=$XDG_CONFIG_HOME/irssi/config --home=$XDG_DATA_HOME/irssi"
alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"
