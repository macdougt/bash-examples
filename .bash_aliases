# Bash aliases


# Builtin bash
alias a='alias'
alias c='clear'
alias g='grep'
alias eg='egrep'

# Not for MAC
if [ "$(uname)" == "Darwin" ]; then
  alias filepath='greadlink -f' 
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  alias ls='ls --color=never --show-control-chars'
fi


alias l='ls -CF'
alias la='ls -A'
alias lal='ls -alhtr'
alias ll='ls -lhtr'
alias pick='picklist'
alias s='source ${HOME}/.profile'
alias t='tail'
alias timestamp='date +%Y.%m.%d-%H.%M.%S'
alias ts=timestamp
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

function find_within_no_binary_function() {
  find . -type f -exec file {} + |   awk -F: '/ASCII text/ {print $1}' | xargs grep $1
}
alias fw_no_binary=find_within_no_binary_function
alias fwnb=find_within_no_binary_function

alias eh="list ${HOME}/.edit_history"

function title {
  echo -ne "\033]0;"$*"\007"
}

function it2prof {
  echo -e "\033]50;SetProfile=$1\a"
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

# Create directory and change to it
function mkcdir ()
{
    /bin/mkdir -p -- "$1" &&
    cd "$1"
}

alias tgz=tgz_function
function tgz_function() {
  filename=$1
  filename_no_end_slash=${filename%%+(/)}
  echo "tar cvfz $filename_no_end_slash.tgz $filename_no_end_slash"
  tar cvfz $filename_no_end_slash.tgz $filename_no_end_slash
}

alias range=range_function
function range_function() {
  let offset=1+$2-$1
  tail +$1 $3 | head -$offset 
}

alias write_function='type -a'
alias py='python3'

alias ports="lsof -iTCP -sTCP:LISTEN -n -P"

alias template=template_function
function template_function() {
  if [ -f "/templates/$1" ]
  then
    echo "Template $1"
    if [ -z "$2" ]
    then
      echo "Creating yo.pl from template $1"
      # Check for yo.pl
      if [ -f "./yo.pl" ]
      then
        echo "yo.pl exists, not overwriting"
        return 1
      else
        cp /templates/$1 ./yo.pl
      fi
    else
      echo "Creating $2 from template $1"
      # Check for file existence of 2nd argument 
      if [ -e "./$1" ]
      then
        echo "$2 exists, not overwriting"
        return 2
      else
        cp /templates/$1 ./$2
      fi
    fi
  else
    echo "No template for $1"
  fi
}



