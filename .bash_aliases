# Bash aliases


# Builtin bash
alias a='alias'
alias c='clear'
alias g='grep'
alias l='ls -CF'
alias la='ls -A'
alias lal='ls -alh'
alias ll='ls -lhtr'
alias s='source ~/.bashrc'
alias u='unalias'
alias valias='vi ~/.bash_aliases'
alias vil='vi `fc -s`'
alias vcs='vi ~/.bashrc'
alias webhere='python -m SimpleHTTPServer '


# For locate
alias lcoate='locate'
alias loc='locate'
alias uloc='updatedb; locate '

# history
function history_function() {
   if [ $# -eq 0 ]
     then
     builtin history | history_unique ;
   else
     builtin history | grep $* | history_unique ;
   fi   
}
alias gh='history | grep $@'
alias h=history_function

# Tracking - bbh
function bbh_function() {
   if [ $# -eq 0 ]
     then
     list ~/.bash_big_history | bbh_unique ;
   else
     list ~/.bash_big_history | grep $* | bbh_unique ;
   fi
}
alias bbh=bbh_function


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

# Docker
alias dockergrep='history| grep docker'
alias dockerRmContainers='docker rm $(docker ps -a -q)'
alias dockerkillall='docker stop $(docker ps -a -q);docker rm $(docker ps -a -q)'
alias dls='docker images;docker ps -a'
alias dockerls='docker images;docker ps -a'
alias dockerlsc='docker ps -a'
alias dockerkillexit='docker ps -aq -f status=exited | xargs docker rm'
alias dockerbash=docb
alias dockerstart=docs


# Docker functions

function dockerCleanFunction() {
   docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
}

alias dockerclean=dockerCleanFunction


function dockerKillFunction() {
   docker stop $*;docker rm $*
}

alias dockerkill=dockerKillFunction

