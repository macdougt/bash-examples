# Installer to standard terminal utilities and functionality

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
      fi
fi

echo "This a $ARCH operating system"

if ! which wget
then
	echo "Need to install wget"
	apt-get install wget
else 
	echo "wget installed already"
fi

# Grab the files
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.bash_aliases -O .bash_aliases
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/.bashrc -O .bashrc
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/appendif -O appendif
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/cdn -O cdn
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/getDir -O getDir
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/cleandh -O cleandh
wget https://raw.githubusercontent.com/macdougt/bash-examples/master/utils/list -O list

chmod +x appendif cdn getDir cleandh list

# Move the files if necessary
if [[ "$PWD" != "$HOME" ]]
then
   mv .bashrc $HOME 
   mv .bash_aliases $HOME
fi

mv appendif cdn getDir cleandh list /usr/local/bin

# Get rid of the temporary directory
rmdir $mytmpdir

