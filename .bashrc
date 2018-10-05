# Eric Lowe's .bashrc file
# for aliases and all of that
# Environment variables and functions in .bash_profile

set -o emacs
set -o noclobber

#   --------------------------------------------------------------------
# Aliases and such

alias pyth='python3'                # call homebrewed Python3 install
alias rm='rm -ir'                   # preferred rm behavior
alias cp='cp -i'                    # preferred cp behavior
alias mv='mv -i'                    # preferred mv behavior
alias mkdir='mkdir -p'              # preferred mkdir behavior
alias du='du -sh'                  # preferred disk usage behavior
alias pwd='pwd -P'                  # preferred pwd behavior
alias path='echo -e ${PATH//:/\\n}' # display path variables on newlines
alias ls='ls -ahlF'                  # preferred ls behavior
alias f='open -a Finder ./'         # opens current dir in Mac OS Finder
alias gstat='git status -b'            # run git status
alias gith='git fetch --all --prune' # hard git fetch
alias gl='git log --graph --pretty'  # git log behavior alias
alias gp='git pull'                 # alias for git pull
# alias to hard update homebrew
alias brwd='cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update && brew upgrade && cd -'
