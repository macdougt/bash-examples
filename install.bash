# Installer to standard terminal utilities and functionality

# This script must not be run as root
if [ "$(id -u)" == "0" ]; then
  echo "This script must not be run as root" 1>&2
  exit 1
fi

# Usage
function usage()
{
  echo "Install utilities from github"
  echo ""
  echo $0 
  echo -e "\t-h --help"
  echo ""
}

path_prepend() {
  for ((i=$#; i>0; i--)); 
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      export PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

path_append() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      export PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

while [[ "$1" != "" ]]; do
  case "$1" in
    -h | --help)    usage; exit;; # Display usage
    *)
      echo "ERROR: unknown parameter \"$PARAM\""
      usage
      exit 1
      ;;
  esac
  shift # Proceed to next argument if necessary
done

# Set the install user
INSTALL_USER=$(whoami)

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
fi

echo "This a $ARCH operating system"

# wget is required
if ! which wget
then
  echo "Need to install wget"
  exit 8
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

# Where is this all going, this will need to be added to the path if not 
# already present
TARGET_BIN_DIR=$HOME_DIR/bin
mkdir -p ${TARGET_BIN_DIR}
path_append ${TARGET_BIN_DIR}

# Set up file groups
DOT_FILES=('.profile' '.bash_aliases' '.bashrc' '.docker_content' '.dirh_content' '.hist_content' '.dm_content' '.dc_content' '.edit_content' '.mac_content' '.overrides' 'update_installer')

BBH_CONTENT='.bbh_content'

UTILITIES=('appendif' 'cdn' 'getDir' 'cleandh' 'cleaneh' 'cd_to_file' 'list' 'dh_list' 'pipelist' 'bu' 'history_unique' 'bbh' 'ips' 'vloc' 'tvi' 'bbq' 'hh' 'bbh2' 'update_file_from_url')
MAC_UTILITIES=('new')
DOCKER_UTILITIES=('docb' 'docs' 'dk' 'dcp')
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

# Move files to end locations
mv $JOIN_DOT_FILES $HOME_DIR
mv $JOIN_UTILITIES $TARGET_BIN_DIR
mv $JOIN_DOCKER_UTILITIES $TARGET_BIN_DIR
mv $JOIN_DOCKER_MACHINE_UTILITIES $TARGET_BIN_DIR
mv $JOIN_PERL_UTILITIES $TARGET_BIN_DIR

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
    mv $JOIN_MAC_UTILITIES $TARGET_BIN_DIR
fi

# Get rid of the temporary directory
rmdir $mytmpdir

echo "You need to add: $TARGET_BIN_DIR to your path"
echo "$PATH"
