for file in ${HOME}/.{bash_aliases,bbh_content,dirh_content,docker_content,dm_content,dc_content,hist_content,edit_content,optional_content}; do
	[[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

case "$TERM" in
xterm*|rxvt*)
    PS1="\e[0;34m[\u@\h \W]\$ \e[m"
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
