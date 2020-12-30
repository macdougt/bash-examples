# Bash aliases
# requirements
# exa, python3, updatedb, wget

# Builtin bash
alias a='dtype'
alias c='clear'
alias eg='egrep'
alias g='grep'

# Not for MAC
if [ "$(uname)" == "Darwin" ]; then
  alias filepath='greadlink -f' 
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  alias ls='ls --color=never --show-control-chars'
fi

alias l='exa'
alias la='ls -A'
alias lal='exa -alh -s=modified'
alias ll='ls -lhtr'
alias path='env | grep ^PATH='
alias pdb='python -m pdb'
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
alias webhere='python -m http.server '
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

  local DASHES="${1:-80}"
  for ((i=1;i<=${DASHES};i++))
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
  if [ -z $3 ]; then
    tail +$1 | head -$offset
  else
    tail +$1 $3 | head -$offset
  fi 
}

alias write_function='type -a'
alias py='python3'


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

function _exchange() {
  basename1="$(basename -- $1)"
  basename2="$(basename -- $2)"
  echo "$basename1"
  echo "$basename2"
  echo "mv $1 $2 /tmp/t1"
  mv $1 $2 /tmp/t1

  # The above copy needs to have completed successfully
  if [[ $? -eq 0 ]]
  then
    echo "cp /tmp/t1/$basename1 $2"
    cp -r /tmp/t1/$basename1 $2
    echo "cp /tmp/t1/$basename2 $1"
    cp -r /tmp/t1/$basename2 $1
  fi
  return $?
}


function exchange() {
  if [ $# -ne 2 ]; then
    echo 1>&2 "Usage: $0 <file/dir> <file/dir>"
    exit 1
  fi
  
  # Validate that they are both the same type
  # and exist
  if [[ -d $1 && -d $2 ]]; then
    echo "Exchanging directories"
    _exchange $1 $2
  elif [[ -f $1 && -f $2 ]]; then
    echo "Exchanging files"
    _exchange $1 $2
  else
    echo "Either the types do not match or at least one of your arguments does not exist"
    exit 2
  fi
}

function ddu() {
  local RESULTS="${1:-20}"
  du -sh * | sort -h | tail -${RESULTS}
}

function dot() {
  egrep "$1" $DOT_FILES_STRING
}

function dot_link() {
  echo -e $(egrep "$1" $DOT_FILES_STRING | sed -E 's/(.*)\/(.+):.*/\\e]8;;vscode:\/\/file\/\1\/\2\\e\\\\\2\\e]8;;\\e\\\\\\n/')
}

alias dtype=dtype_function
function dtype_function() {
  if [ -z $1 ]
  then
    alias
  else
    # Processing output looking for aliases then run type on the 
    # output. The structure of the while read loop allows input
    # from the done line (ref: http://www.compciv.org/topics/bash/loops)
    while read l1 ;do
      regex="aliased to \`(.*)'"

      echo $l1

      if [[ $l1 =~ $regex ]];then     
        name="${BASH_REMATCH[1]}"
        type $name
      fi
    done < <(type $*)

    OUTPUT=$(dot_link "alias $1\b|function $1\b")

    if [[ $OUTPUT ]]; then
      echo ""
      echo "Found in:"
      echo "---------"
      echo $OUTPUT
    fi
    # TODO could go deeper
  fi
}
