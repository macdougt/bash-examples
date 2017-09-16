# Installer to standard terminal utilities and functionality

# This script must be run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

function usage()
{
    echo "Install utilities from github"
    echo ""
    echo $0 
    echo -e "\t-h --help"
    echo -e "\t-u=[username] or --user=[username]"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -u | --user)
            INSTALL_USER=$VALUE
	    # check if the user exists
            ERROR_MESSAGE=$(id -u $INSTALL_USER 2>&1)
            if [ $? != 0 ]
            then
              echo $ERROR_MESSAGE
              exit 1
            fi
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [ -z "$INSTALL_USER" ]; then
  INSTALL_USER=$(logname) # sudoing user
fi

echo "I am installing for $INSTALL_USER. Should I continue?[y/N]"
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

cd $mytmpdir

if [ "$(uname)" == "Darwin" ]; then
   ARCH='mac'
   echo "This terminal appears to be running MAC os"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   ARCH='linux'
   echo "This terminal appears to be running a linux os"
   # Check if the vimrc has compatibility mode set
   if grep "set nocompatible" $HOME/.vimrc
      then
	echo "Non-compatibility mode is set"
      else
	echo "Adding non-compatibility mode to vi"
	echo "set nocompatible" >> $HOME/.vimrc
	echo "Adding local history to vi"
	echo "autocmd BufWritePost * execute '! if [ -d RCS ]; then ci -u -m\"%\" % ; co -l %; fi'" >> $HOME/.vimrc
      fi
fi

echo "This a $ARCH operating system"

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

DOT_FILES=('.profile' '.bash_aliases' '.bashrc' '.docker_content' '.dirh_content' '.hist_content' '.bbh_content' '.dm_content' '.dc_content' '.edit_content' '.mac_content' 'update_installer')
UTILITIES=('appendif' 'cdn' 'getDir' 'cleandh' 'cleaneh' 'cd_to_file' 'list' 'dh_list' 'pipelist' 'bu' 'history_unique' 'bbh_unique' 'ips' 'vloc' 'tvi' 'bbq' 'hh')
MAC_UTILITIES=('new')
DOCKER_UTILITIES=('docb' 'docs')
DOCKER_MACHINE_UTILITIES=('dm_connect')
PERL_UTILITIES=('picklist')

JOIN_DOT_FILES=$(echo ${DOT_FILES[@]})
JOIN_UTILITIES=$(echo ${UTILITIES[@]})
JOIN_DOCKER_UTILITIES=$(echo ${DOCKER_UTILITIES[@]})
JOIN_DOCKER_MACHINE_UTILITIES=$(echo ${DOCKER_MACHINE_UTILITIES[@]})
JOIN_PERL_UTILITIES=$(echo ${PERL_UTILITIES[@]})

# Grab the dot files 
for DOT_FILE in "${DOT_FILES[@]}"
do
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/$DOT_FILE -O $DOT_FILE 
done

# Grab the bash utilities
for UTIL in "${UTILITIES[@]}"
do
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/$UTIL -O $UTIL 
done

# Grab the docker utilities
for DOCKER_UTIL in "${DOCKER_UTILITIES[@]}"
do
wget https://raw.githubusercontent.com/macdougt/docker-examples/master/$DOCKER_UTIL -O $DOCKER_UTIL 
done

# Grab the docker machine utilities
for DOCKER_MACHINE_UTIL in "${DOCKER_MACHINE_UTILITIES[@]}"
do
wget https://raw.githubusercontent.com/macdougt/docker-machine-examples/master/$DOCKER_MACHINE_UTIL -O $DOCKER_MACHINE_UTIL 
done

# Grab the perl utilities
for PERL_UTIL in "${PERL_UTILITIES[@]}"
do
wget https://raw.githubusercontent.com/macdougt/perl-examples/master/utils/$PERL_UTIL -O $PERL_UTIL 
done

chmod +x $JOIN_UTILITIES
chmod +x $JOIN_DOCKER_UTILITIES
chmod +x $JOIN_DOCKER_MACHINE_UTILITIES
chmod +x $JOIN_PERL_UTILITIES


PRIMARY_GROUP=$(id -g -n $INSTALL_USER)
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_DOT_FILES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_UTILITIES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_DOCKER_UTILITIES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_DOCKER_MACHINE_UTILITIES 
chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_PERL_UTILITIES 

mv $JOIN_DOT_FILES $HOME
mv $JOIN_UTILITIES /usr/local/bin
mv $JOIN_DOCKER_UTILITIES /usr/local/bin
mv $JOIN_DOCKER_MACHINE_UTILITIES /usr/local/bin
mv $JOIN_PERL_UTILITIES /usr/local/bin


if [ "$ARCH" == "mac" ]
  then
    # Grab the MAC utilities
    for MAC_UTIL in "${MAC_UTILITIES[@]}"
    do
    wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/$MAC_UTIL -O $MAC_UTIL 
    done

    JOIN_MAC_UTILITIES=$(echo ${MAC_UTILITIES[@]})
    chmod +x $JOIN_MAC_UTILITIES
    chown $INSTALL_USER:$PRIMARY_GROUP $JOIN_MAC_UTILITIES
    mv $JOIN_MAC_UTILITIES /usr/local/bin
fi


# Get rid of the temporary directory
rmdir $mytmpdir
