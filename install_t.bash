# Installer to standard terminal utilities and functionality

# This script must be run as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Usage
function usage()
{
  echo "Install utilities from github"
  echo ""
  echo $0 
  echo -e "\t-h --help"
  echo -e "\t-u=[username] or --user=[username]"
  echo ""
}

# Compare files with files of same name in specified directory
function compare_files() {
  MY_DIR=$1
  shift
  MY_TEMP_DIR=$1
  shift
  echo "Set to compare files: $* to those in $MY_DIR"

  # First compare
  echo ""
  echo "Differences in $MY_DIR"
  echo "--------------------------------"
  echo "" 
  for cur_file in "$@"
  do
    cmp $cur_file $MY_DIR/$cur_file
  done

  # Run diffs
  for cur_file in "$@"
  do
    if ! cmp -s $cur_file $MY_DIR/$cur_file
    then
      echo ""
      echo "sudo diff $MY_TEMP_DIR/$cur_file $MY_DIR/$cur_file"
      echo "sudo /Applications/DiffMerge.app/Contents/Resources/diffmerge.sh $MY_TEMP_DIR/$cur_file $MY_DIR/$cur_file"
      echo "--------------------------------"
      echo "" 
      diff $cur_file $MY_DIR/$cur_file
    fi
  done
}

# Cheap processing of arguments
export DRY_RUN=0

while [[ "$1" != "" ]]; do
  case "$1" in
    -h | --help)    usage; exit;; # Display usage
    -u | --user)
      INSTALL_USER=$2
      # check if the user exists
      ERROR_MESSAGE=$(id -u $INSTALL_USER 2>&1)
      if [ $? != 0 ]
      then
        echo $ERROR_MESSAGE
        exit 1
      fi
      shift;;
    -n | --dry-run)
      DRY_RUN=1;;
    *)
      echo "ERROR: unknown parameter \"$PARAM\""
      usage
      exit 1
      ;;
  esac
  shift # Proceed to next argument if necessary
done

# Set the install user
# TODO shouldn t this fail if the user does not exist
if [ -z "$INSTALL_USER" ]; then
  if [ "$(uname)" == "Darwin" ]; then
    INSTALL_USER=$(logname) # sudoing user
  else
    INSTALL_USER=$(whoami)
  fi
fi

if [ $DRY_RUN -eq 1 ]; then
  echo "This script is running as a dry run"
else 
  echo "MODIFICATIONS: This script is NOT running as a dry run"
fi

echo ""
echo "I am installing for $INSTALL_USER with bash ${BASH_VERSINFO}. Should I continue?[y/N]"
read ANSWER
if [ "$ANSWER" != "y" ] && [ "$ANSWER" != "Y" ]; then
  echo "Exiting"
  exit 0
fi

# Operate in a temporary directory
# Check for mktemp
if ! which mktemp
then
  echo "You need to install mktemp to use this script"
  exit
fi

mytmpdir=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`
echo "This script will be operating in $mytmpdir"

# Work in the temporary directory
cd $mytmpdir

# Deal with OS specifics
if [ "$(uname)" == "Darwin" ]; then
  ARCH='mac'
  echo "This terminal appears to be running MAC os"

  # Set the home directory of the INSTALL_USER
  HOME_DIR=$(dscacheutil -q user -a name $INSTALL_USER | grep dir | cut -d':' -f2)

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  ARCH='linux'
  echo "This terminal appears to be running a linux os"

  # Set the home directory of the INSTALL_USER
  HOME_DIR=$( getent passwd "$INSTALL_USER" | cut -d: -f6 )

  # Check if the vimrc has compatibility mode set
  if grep "set nocompatible" $HOME_DIR/.vimrc
  then
  echo "Non-compatibility mode is set"
  else
  echo "Adding non-compatibility mode to vi"
  echo "set nocompatible" >> $HOME_DIR/.vimrc
  echo "Adding local history to vi"
  echo "autocmd BufWritePost * execute '! if [ -d RCS ]; then ci -u -m\"%\" % ; co -l %; fi'" >> $HOME_DIR/.vimrc
  fi
fi

echo "This a $ARCH operating system"

# wget is required
if ! which wget
then
  echo "Need to install wget"
  if [ "$ARCH" == "linux" ]
  then
    apt-get install wget
  elif [ "$ARCH" == "mac" ]
  then
    brew install wget
  else
    echo "I do not recognize architecture $ARCH"
    exit 2
  fi 
else 
	echo "wget installed already"
fi

# Perl is required
if ! which perl
then
  echo "Need to install perl"
  if [ "$ARCH" == "linux" ]
  then
    apt-get install perl
  elif [ "$ARCH" == "mac" ]
  then
    brew install perl
  else
    echo "I do not recognize architecture $ARCH"
    exit 2
  fi
else
  echo "perl installed already"
fi

# Set up file groups
DOT_FILES=('.profile' '.bash_aliases' '.bashrc' '.docker_content' '.dirh_content' '.hist_content' '.dm_content' '.dc_content' '.edit_content' '.mac_content' '.overrides' 'update_installer')

BBH_CONTENT='.bbh_content'

UTILITIES=('appendif' 'cdn' 'getDir' 'cleandh' 'cleaneh' 'cd_to_file' 'list' 'dh_list' 'pipelist' 'bu' 'history_unique' 'bbh' 'ips' 'vloc' 'tvi' 'bbq' 'hh' 'bbh2' 'update_file_from_url')
MAC_UTILITIES=('new')
DOCKER_UTILITIES=('docb' 'docs')
DOCKER_MACHINE_UTILITIES=('dm_connect')
PERL_UTILITIES=('picklist')

JOIN_DOT_FILES=$(echo ${DOT_FILES[@]} $BBH_CONTENT)
JOIN_UTILITIES=$(echo ${UTILITIES[@]})
JOIN_DOCKER_UTILITIES=$(echo ${DOCKER_UTILITIES[@]})
JOIN_DOCKER_MACHINE_UTILITIES=$(echo ${DOCKER_MACHINE_UTILITIES[@]})
JOIN_PERL_UTILITIES=$(echo ${PERL_UTILITIES[@]})

# Grab the dot files

echo "About to wget..."

for DOT_FILE in "${DOT_FILES[@]}"
do
  echo "$DOT_FILE"
  wget --quiet https://raw.githubusercontent.com/macdougt/bash-examples/master/$DOT_FILE -O $DOT_FILE 
done

# bbh 
if [ "${BASH_VERSINFO}" -lt 4 ]; then
  echo "bash ${BASH_VERSINFO} less than 4, choosing .bbh_content"
  wget --quiet https://raw.githubusercontent.com/macdougt/bash-examples/master/$BBH_CONTENT -O $BBH_CONTENT 
else
  echo "bash ${BASH_VERSINFO} greater than or equal to 4, choosing .bbh_content.bash4"
  wget --quiet https://raw.githubusercontent.com/macdougt/bash-examples/master/$BBH_CONTENT.bash4 -O $BBH_CONTENT
fi

# Grab the bash utilities
for UTIL in "${UTILITIES[@]}"
do
  echo "$UTIL"
  wget --quiet https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/$UTIL -O $UTIL 
done

# Grab the docker utilities
for DOCKER_UTIL in "${DOCKER_UTILITIES[@]}"
do
  echo $DOCKER_UTIL
  wget --quiet https://raw.githubusercontent.com/macdougt/docker-examples/master/$DOCKER_UTIL -O $DOCKER_UTIL 
done

# Grab the docker machine utilities
for DOCKER_MACHINE_UTIL in "${DOCKER_MACHINE_UTILITIES[@]}"
do
  echo $DOCKER_MACHINE_UTIL
  wget --quiet https://raw.githubusercontent.com/macdougt/docker-machine-examples/master/$DOCKER_MACHINE_UTIL -O $DOCKER_MACHINE_UTIL 
done

# Grab the perl utilities
for PERL_UTIL in "${PERL_UTILITIES[@]}"
do
  echo $PERL_UTIL
  wget --quiet https://raw.githubusercontent.com/macdougt/perl-examples/master/utils/$PERL_UTIL -O $PERL_UTIL 
done

# Set file permissions
chmod +x $JOIN_UTILITIES
chmod +x $JOIN_DOCKER_UTILITIES
chmod +x $JOIN_DOCKER_MACHINE_UTILITIES
chmod +x $JOIN_PERL_UTILITIES

# Set file ownership and group
PRIMARY_GROUP=$(id -g -n $INSTALL_USER)
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_DOT_FILES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_UTILITIES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_DOCKER_UTILITIES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_DOCKER_MACHINE_UTILITIES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_PERL_UTILITIES 

# Compare (if specified)
if [ $DRY_RUN -eq 1 ]; then
  echo "Only a dry run"
  compare_files $HOME_DIR $mytmpdir $JOIN_DOT_FILES
  compare_files /usr/local/bin $mytmpdir $JOIN_UTILITIES
  compare_files /usr/local/bin $mytmpdir $JOIN_DOCKER_UTILITIES
  compare_files /usr/local/bin $mytmpdir $JOIN_DOCKER_MACHINE_UTILITIES
  compare_files /usr/local/bin $mytmpdir $JOIN_PERL_UTILITIES

  # Remove temp directory
  #/usr/local/bin/trash $mytmpdir
  exit
fi

# Move files to end locations
mv $JOIN_DOT_FILES $HOME_DIR
mv $JOIN_UTILITIES /usr/local/bin
mv $JOIN_DOCKER_UTILITIES /usr/local/bin
mv $JOIN_DOCKER_MACHINE_UTILITIES /usr/local/bin
mv $JOIN_PERL_UTILITIES /usr/local/bin

# Add OS specific content
if [ "$ARCH" == "mac" ]
  then
    # Grab the MAC utilities
    for MAC_UTIL in "${MAC_UTILITIES[@]}"
    do
      wget --quiet https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/$MAC_UTIL -O $MAC_UTIL 
    done

    JOIN_MAC_UTILITIES=$(echo ${MAC_UTILITIES[@]})
    chmod +x $JOIN_MAC_UTILITIES
    chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_MAC_UTILITIES
    mv $JOIN_MAC_UTILITIES /usr/local/bin
fi

# Get rid of the temporary directory
rmdir $mytmpdir
