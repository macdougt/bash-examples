for file in ${HOME}/.{bash_aliases,bbh_content,dirh_content,docker_content,dm_content,dc_content,hist_content,edit_content,optional_content}; do
	[[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

# Add MAC specific content
if [ "$(uname)" == "Darwin" ]; then
  source ${HOME}/.mac_content
fi

case "$TERM" in
xterm*|rxvt*)
  BLUE="\[$(tput setaf 4)\]"
  RESET="\[$(tput sgr0)\]"
  export PS1="${BLUE}[\u@\h \W]\$ ${RESET}"
#    PS1="\e[0;34m[\u@\h \W]\$ \e[m"
#    PS1="\033[34m\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1\\033[39m"
    ;;
*)
    ;;
esac

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Powerline; check if powerline is used
function _update_ps1() {
  PS1="$(powerline-shell $?)"
}

if command -v powerline-shell > /dev/null 2>&1; then
  if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
  fi
else
  echo "powerline-shell not found"
fi

