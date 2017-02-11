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

alias l='ls -CF'
alias la='ls -A'
alias lal='ls -alhtr'
alias ll='ls -lhtr'
alias s='source ~/.profile'
alias u='unalias'
alias valias='vi ~/.bash_aliases'
alias vil='vi `fc -s`'
alias vcs='vi ~/.bashrc'
alias webhere='python -m SimpleHTTPServer '


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
  locate $1 | grep $1\$ | xargs grep $2 
}
alias fw=find_within_function
alias findwithin=find_within_function

function find_below_function() {
   find . -name "$1"
}
alias fb=find_below_function

alias eh="list ~/.edit_history"

function title {
    echo -ne "\033]0;"$*"\007"
}


