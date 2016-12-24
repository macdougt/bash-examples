# Bash aliases


# Builtin bash
alias a='alias'
alias c='clear'
alias g='grep'
# Not for MAC
alias ls='ls -F --color=never --show-control-chars'
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

function findWithin() {
  locate $1 | grep $1\$ | xargs grep $2 
}

alias fw=findWithin
alias findwithin=findWithin

