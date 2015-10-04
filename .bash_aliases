# Bash aliases

alias a='alias'
alias u='unalias'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias h='history'
alias vcs='vi ~/.bashrc'
alias s='source ~/.bashrc'
alias dockergrep='history| grep docker'
alias dockerRmContainers='docker rm $(docker ps -a -q)'
alias dockerkillall='docker stop $(docker ps -a -q);docker rm $(docker ps -a -q)'
alias dls='docker images;docker ps -a'
alias dockerls='docker images;docker ps -a'
alias dockerlsc='docker ps -a'

alias dh='list ~/.dirhistory'
alias lal='ls -al'
alias sdh='dh | grep $@'
alias bbh='list ~/.bash_big_history'

function webhere() { python -m SimpleHTTPServer $1; }
export -f webhere

alias vil='vi `fc -s`'

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

