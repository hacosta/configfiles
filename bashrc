export PATH=.:~/bin:/home/hacosta/.gem/ruby/1.8/bin:$PATH
export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '/
function :h () {  vim --cmd ":silent help $@" --cmd "only"; }

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

#para el trailing / en symlinks
#set mark-symlinked-directories on
#completion más densa
COMP_CONFINGURE_HINTS=1
GREP_OPTIONS="--exclude-dir=\.svn"

if [ "$PS1" ]; then
  if which fortune &> /dev/null; then
      echo
      /usr/bin/fortune -ac
      echo
  fi
fi

if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

#variables interesantes
export KDE_NO_IPV6="true"
export KDE_IS_PRELINKED="true"
export PROMPT_COMMAND='history -a'
export HISTCONTROL="ignoredups"
export EDITOR="vim"
export HISTSIZE=1000
export HISTFILESIZE=1000
export LESSOPEN="|lesspipe.sh %s"
export HISTCONTROL=ignoredups
export DEBUG=1
export LC_TIME=C

alias grep="grep --color=auto"
alias nano="nano -w"
alias wget="wget --timeout 10"
alias x="startx"
alias ls='ls --color=auto -Fh'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias l='ls'
alias screen='screen -U'
alias ri='ri -f ansi'
alias halt='sudo halt'
alias shutdown='sudo shutdown'
alias reboot='sudo reboot'
which pacman &> /dev/null && alias pacman='sudo pacman'
alias aurbuild='sudo aurbuild'
alias p='pacman'
alias svim='sudo vim'
alias svimdiff='sudo vimdiff'

if [ -f /usr/bin/festival ]; then
    alias say='festival --tts'
fi
#
test -n "$DISPLAY" && export TERM=xterm-color
#
#
#################FUNCIONES###################
##extraer archivos
ex () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
#
##ponerle titulo
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



#PS1-related
host2color()
{
    #'\e[0;30m' # Black - Regular
    local colors=(
    '\e[0;31m' \
    '\e[0;32m' \
    '\e[0;33m' \
    '\e[0;34m' \
    '\e[0;35m' \
    '\e[0;36m' \
    '\e[0;37m' \
    '\e[1;30m' \
    '\e[1;31m' \
    '\e[1;32m' \
    '\e[1;33m' \
    '\e[1;34m' \
    '\e[1;35m' \
    '\e[1;36m' \
    '\e[1;37m' \
    )
    txtrst='\e[0m'    # Text Reset
    sum=${#colors[@]}
    (( str_len=${#HOSTNAME} - 1 ))
    for i in $(seq 0 $str_len); do
        (( sum=$(printf "%d" "'${HOSTNAME:$i:1}'") + $sum ))
    done
    (( random_color = $sum % ${#colors[@]} ))
    echo -e ${colors[$random_color]}
}
HOST_COLOR=$(host2color)




PS1='[$?]\[\033[01;32m\]\u@\[$HOST_COLOR\]\h \w %\[\033[00m\] '
