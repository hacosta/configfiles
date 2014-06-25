export PATH=.:~/bin:/home/hacosta/.gem/ruby/1.8/bin:$PATH
export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '/

complete -A setopt set
complete -A user groups id
complete -A binding bind
complete -A helptopic help
complete -A alias {,un}alias
complete -A signal -P '-' kill
complete -A stopped -P '%' fg bg
complete -A job -P '%' jobs disown
complete -A variable readonly unset
complete -A file -A directory ln chmod
complete -A user -A hostname finger pinky
complete -A directory find cd pushd {mk,rm}dir
complete -A file -A directory -A user chown
complete -A file -A directory -A group chgrp
complete -o default -W 'Makefile' -P '-o ' qmake
complete -A command man which whatis whereis info apropos
complete -A file {,z}cat pico nano vi {,{,r}g,e,r}vi{m,ew} vimdiff elvis emacs {,r}ed e{,x} joe jstar jmacs rjoe jpico {,z}less {,z}more p{,g}
complete -d cd
complete -cf sudo
shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
#shopt -s nullglob

COMP_CONFINGURE_HINTS=1
GREP_OPTIONS="--exclude-dir=\.svn"

if [ "$PS1" ]; then
	which fortune &> /dev/null && fortune -c
fi

for i in /etc/bash_completion /usr/share/bash-completion/bash_completion; do
	if [ -f "$i" ]; then
		source "$i"
	fi
done

export KDE_NO_IPV6="true"
export PROMPT_COMMAND='history -a'
export HISTCONTROL="ignoredups"
export EDITOR="vim"
export HISTSIZE=1000
export HISTFILESIZE=1000
export HISTCONTROL=ignoredups
export DEBUG=1
export LC_TIME=C
export PYTHONSTARTUP=~/.pythonrc.py
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dcom.sun.java.swing.plaf.gtk.GTKLookAndFeel"

alias grep="grep --color=auto"
alias nano="nano -w"
alias wget="wget --timeout 10"
alias x="startx"
if ls --color -d . &> /dev/null ; then
	alias ls='ls --color=auto -Fh'
fi
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias l='ls'
alias screen='screen -U'
alias ri='ri -f ansi'
if which sudo &> /dev/null; then
	alias halt='sudo halt'
	alias shutdown='sudo shutdown'
	alias reboot='sudo reboot'
	which pacman &> /dev/null && alias pacman='sudo pacman'
	alias aurbuild='sudo aurbuild'
	alias p='sudo pacman'
	alias svim='sudo vim'
	alias svimdiff='sudo vimdiff'
fi

if [ -f /usr/bin/festival ]; then
    alias say='festival --tts'
fi
#
test -n "$DISPLAY" && export TERM=xterm-256color

case $TERM in
        xterm*|rxvt*|Eterm)
                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
                ;;
        screen)
                PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
                ;;
esac

netinfo ()
{
  echo "--------------- Network Information ---------------"
  /sbin/ifconfig | awk /'inet addr/ {print $2}'
  /sbin/ifconfig | awk /'Bcast/ {print $3}'
  /sbin/ifconfig | awk /'inet addr/ {print $4}'
  /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
  myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
  echo "${myip}"
  echo "---------------------------------------------------"
}
#
psm()
{
    echo '%CPU %MEM   PID COMMAND' && ps hgaxo %cpu,%mem,pid,comm | sort -nrk1 | head -n 10 | sed -e 's/-bin//' | sed -e 's/-media-play//'
}

## Try to keep environment pollution down, EPA loves us.
unset use_color safe_term
ulimit -c 10000000


str2color()
{
	[ -z "$1" ] && return
	hex=$(echo -n "$1" |md5sum| head -c 2)
	printf "\e[48;5;0m\e[38;5;%dm" 0x$hex
}

if command -v reptyr &> /dev/null; then
	attach()
	{
		proc="$1"
		[[ -z "$proc" ]] && return 1
		if [[ "$proc" =~ ^[0-9]+$ ]]; then
			reptyr $1
		elif kill -0 $(pidof $proc) &> /dev/null; then
			reptyr $(pidof $proc)
		else
			return 1
		fi
	}
fi

__git_ps1 ()
{
	local b="$(git symbolic-ref HEAD 2>/dev/null)";
	if [ -n "$b" ]; then
		printf " (%s)" "${b##refs/heads/}";
	fi
}

show_error_on_non_0()
{
	[ $1 -ne 0 ] && printf [$1]
}

rsync_inc()
{
	echo This will delete files that do not exist in $2. Press Crtl-C to cancel
	read
	rsync --modify-window=1 --progress -vaz --delete $1/ $2
}

export DEBEMAIL="Héctor Acosta <hector.acosta@gazzang.com>"
export DEBFULLNAME="Héctor Acosta"
host_color=$(str2color $HOSTNAME)
PS1='\[\e[1;31m\]$(show_error_on_non_0 $?)\[\e[;032m\]\u@\[$host_color\]\h \[\e[0;34m\]$(__git_ps1 2> /dev/null)\[\e[0m\]\w\$ '

for i in /usr/bin/virtualenvwrapper.sh /etc/bash_completion.d/virtualenvwrapper; do
	if [ -f $i ]; then
		export WORKON_HOME=$HOME/.virtualenvs
		source $i
	fi
done

if [ -f "$HOME/.creds" ]; then
	source .creds
fi
