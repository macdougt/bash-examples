# Installer to standard terminal utilities and functionality
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

# Move the files if necessary
if [[ "$PWD" != "$HOME" ]]
then
   mv .bashrc $HOME 
   mv .bash_aliases $HOME
fi
