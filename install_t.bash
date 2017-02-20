# Installer to standard terminal utilities and functionality

# This script must be run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
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

DOT_FILES=('.profile' '.bash_aliases' '.bashrc' '.docker_content' '.dirh_content' '.hist_content' '.bbh_content' '.dm_content' '.dc_content' 'update_installer')
UTILITIES=('appendif' 'cdn' 'getDir' 'cleandh' 'cd_to_file' 'list' 'bu' 'history_unique' 'bbh_unique' 'ips' 'vloc' 'tvi' 'bbq')
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


SUDOING_USER=$(logname)
PRIMARY_GROUP=$(id -g -n $SUDOING_USER)
chown $SUDOING_USER:$PRIMARY_GROUP $JOIN_DOT_FILES 
chown $SUDOING_USER:$PRIMARY_GROUP $JOIN_UTILITIES 
chown $SUDOING_USER:$PRIMARY_GROUP $JOIN_DOCKER_UTILITIES 
chown $SUDOING_USER:$PRIMARY_GROUP $JOIN_DOCKER_MACHINE_UTILITIES 
chown $SUDOING_USER:$PRIMARY_GROUP $JOIN_PERL_UTILITIES 


# Move the files if necessary
if [[ "$PWD" != "$HOME" ]]
then
   # TODO back up the bashrc and bash aliases files in a non-destructive way
   mv .bashrc $HOME 
   mv .bash_aliases $HOME
fi

mv $JOIN_DOT_FILES $HOME
mv $JOIN_UTILITIES /usr/local/bin
mv $JOIN_DOCKER_UTILITIES /usr/local/bin
mv $JOIN_DOCKER_MACHINE_UTILITIES /usr/local/bin
mv $JOIN_PERL_UTILITIES /usr/local/bin

# Get rid of the temporary directory
rmdir $mytmpdir
