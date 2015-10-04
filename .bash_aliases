# Bash aliases


# Builtin bash
alias a='alias'
alias c='clear'
alias gh='history | grep $@'
alias h='history'
alias l='ls -CF'
alias la='ls -A'
alias lal='ls -al'
alias ll='ls -ltr'
alias s='source ~/.bashrc'
alias u='unalias'
alias valias='vi ~/.bash_aliases'
alias vil='vi `fc -s`'
alias vcs='vi ~/.bashrc'
alias webhere='python -m SimpleHTTPServer '


# Tracking - bbh
alias bbh='list ~/.bash_big_history'


# dirhistory
alias dh='list ~/.dirhistory'
alias sdh='dh | grep $@'
# Override cd - change directory
function cd() { builtin cd "$@" && appendif `pwd`;}
export -f cd
function cn() { cd `cdn $1`; }
export -f cn
function cdd() { cd `getDir $1`; }
export -f cdd

function backup() {
   cp $1 $1.bak;
}

alias bu=backup


# Docker
alias dockergrep='history| grep docker'
alias dockerRmContainers='docker rm $(docker ps -a -q)'
alias dockerkillall='docker stop $(docker ps -a -q);docker rm $(docker ps -a -q)'
alias dls='docker images;docker ps -a'
alias dockerls='docker images;docker ps -a'
alias dockerlsc='docker ps -a'

# Docker functions
function dockerBashFunction() {
   docker exec -i -t $1 bash
}

alias dockerbash=dockerBashFunction
alias docb='dockerbash'

function dockerCleanFunction() {
   docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
}

alias dockerclean=dockerCleanFunction

function dockerStartFunction() {
   docker run -i -t $1 /bin/bash
}

alias dockerstart=dockerStartFunction

function dockerKillFunction() {
   docker stop $1;docker rm $1
}

alias dockerkill=dockerKillFunction

