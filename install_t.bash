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


# Grab the files
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.profile -O .profile
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.bash_aliases -O .bash_aliases
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.bashrc -O .bashrc
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.docker_content -O .docker_content
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.dirh_content -O .dirh_content
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.hist_content -O .hist_content
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.bbh_content -O .bbh_content
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.dm_content -O .dm_content
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/update_installer -O update_installer 

# Grab the bash utilities
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/appendif -O appendif
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/cdn -O cdn
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/getDir -O getDir
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/cleandh -O cleandh
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/list -O list
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/bu -O bu
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/history_unique -O history_unique
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/bbh_unique -O bbh_unique
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/ips -O ips
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/vloc -O vloc
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/tvi -O tvi
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/cd_to_file -O cd_to_file

# Grab the docker utilities
wget https://raw.githubusercontent.com/macdougt/docker-examples/master/docb -O docb
wget https://raw.githubusercontent.com/macdougt/docker-examples/master/docs -O docs
wget https://raw.githubusercontent.com/macdougt/docker-machine-examples/master/dm_connect -O dm_connect


UTILITIES="appendif cdn getDir cleandh cd_to_file list bu history_unique bbh_unique docb docs ips vloc dm_connect tvi update_installer"

chmod +x $UTILITIES

PRIMARY_GROUP=$(id -g -n $USER)
chown $USER:$PRIMARY_GROUP $UTILITIES 


# Move the files if necessary
if [[ "$PWD" != "$HOME" ]]
then
   # TODO back up the bashrc and bash aliases files in a non-destructive way
   mv .bashrc $HOME 
   mv .bash_aliases $HOME
fi

mv $UTILITIES /usr/local/bin
mv .profile .bash_aliases .bashrc .docker_content .dirh_content .hist_content .bbh_content .dm_content ~

# Get rid of the temporary directory
rmdir $mytmpdir
