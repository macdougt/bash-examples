# Bash aliases


# Builtin bash
alias a='alias'
alias c='clear'
alias g='grep'

# Not for MAC
if [ "$(uname)" == "Darwin" ]; then
   alias ls='ls -CF'
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   alias ls='ls -F --color=never --show-control-chars'
fi


alias filepath='greadlink -f' 
alias l='ls -CF'
alias la='ls -A'
alias lal='ls -alhtr'
alias ll='ls -lhtr'
alias pick='picklist'
alias s='source ${HOME}/.profile'
alias u='unalias'
alias valias='vi ${HOME}/.bash_aliases'
alias vi='tvi'
alias vil='vi `fc -s`'
alias vcs='vi ${HOME}/.bashrc'
alias updatedb='sudo updatedb'
alias webhere='python -m SimpleHTTPServer '
alias utils='wget https://raw.githubusercontent.com/macdougt/bash-examples/master/install_t.bash -O install_t.bash'

# For locate
alias lcoate='locate'
alias loc='locate'
alias uloc='updatedb; locate '

function locate_exact_function() {
  locate $1 | grep $1\$
}
alias locate_exact=locate_exact_function
alias le=locate_exact_function

function find_within_function() {
  locate $2 | grep $2\$ | xargs grep $1 
}
alias fw=find_within_function
alias findwithin=find_within_function

function find_below_function() {
   find . -name "$1"
}
alias fb=find_below_function

alias eh="list ${HOME}/.edit_history"

function title {
   echo -ne "\033]0;"$*"\007"
}

function hline_function() {
   for ((i=1;i<=$1;i++))
   do
   printf '\e(0\x71\e(B%.0s'
   done
   echo '' 
}
alias hline=hline_function
alias sep='echo "";hline 100;echo ""'
alias mkdir=mkcdir
function mkcdir ()
{
    /bin/mkdir -p -- "$1" &&
    cd "$1"
}

