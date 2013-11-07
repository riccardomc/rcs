# apply only to interactive shells
[ -z "$PS1" ] && return 

#
# Bash options
#
HISTCONTROL=ignoreboth              # ignoredups and ignorespace
HISTFILESIZE=50000                  # n lines of history
shopt -s histappend                 # append to history file
shopt -s checkwinsize               # check window size at each cmd

#
# Aliases
#
alias grep='grep -I'                # dont't mactch binary files
alias ls='ls -F'                    # classify
alias ll='ls -Fl'                   # list
alias la='ls -Fa'                   # all
alias lal='ls -Fal'                 # list all

# additional alias definitions
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

#
# TERM
#
# cope with gnome-terminal $TERM settings
if [[ $TERM == xterm && $COLORTERM == gnome* ]]; then
  export TERM=xterm-256color
fi

# try to upgrade TERM to a 256color one, if supported
POTENTIAL_TERM=${TERM}-256color
POTENTIAL_TERMINFO=${TERM:0:1}/$POTENTIAL_TERM

BOX_TERMINFO_DIR=/usr/share/terminfo
[[ -f $BOX_TERMINFO_DIR/$POTENTIAL_TERMINFO ]] && \
export TERM=$POTENTIAL_TERM

HOME_TERMINFO_DIR=$HOME/.terminfo
[[ -f $HOME_TERMINFO_DIR/$POTENTIAL_TERMINFO ]] && \
export TERM=$POTENTIAL_TERM

#
# PS1 and Colors
#
# debian chroot
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

parse_git_branch() {
    ref=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null) || return
    echo $ref
}

# default prompt
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# use colors and colorize output in Darwin
case "$TERM" in
  xterm* | screen*)
    export CLICOLOR=1
esac

if [[ $CLICOLOR -eq 1 ]] ; then
  X='\[\e[0m\]'    # Text Reset
  K='\[\e[0;90m\]' # Black
  R='\[\e[0;91m\]' # Red
  G='\[\e[0;92m\]' # Green
  Y='\[\e[0;93m\]' # Yellow
  B='\[\e[0;94m\]' # Blue
  M='\[\e[0;95m\]' # Magenta
  C='\[\e[0;96m\]' # Cyan
  W='\[\e[0;97m\]' # White
  U=$G         # User color

  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -F --color=auto'
    alias ll='ls -Fl --color=auto'
    alias la='ls -Fa --color=auto'
    alias lal='ls -Fal --color=auto'

  fi

  alias grep='grep -I --color=auto'
  alias fgrep='fgrep -I --color=auto'
  alias egrep='egrep -I --color=auto'

  if [ $UID -eq 0 ] ; then
    U=$R
  fi

  PS1="$X${debian_chroot:+($debian_chroot)}$U\u@\h$X:$C\j$X:$B\w:$Y\$(parse_git_branch '%s')$X\$ "
fi


# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi


#
# OS specific configs
#
if [ "$(uname)" = "Darwin" ]; then
  alias tgvim="mvim -p --remote-tab-silent"

  export PYTHON_PATH="/opt/local//library/frameworks/python.framework/versions/2.7:$PYTHON_PATH"
  export XDG_DATA_DIRS="$PYTHON_PATH/share"

  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH

  #this is for vim installed by brew to have ruby support
  export PATH=/usr/local/cellar/vim/7.3.762/bin:$PATH
else
  alias tgvim="gvim -p --remote-tab-silent"
fi


#
# Host specific configs 
#
case $HOSTNAME in
  fs0*|fs2*)
    stty erase ^? #fix backspace
    export SNET_DIR=/var/scratch/$USER/snet
    module load gcc
    module load sge 
    module load openmpi/gnu
    ;;
  *sara.nl)
    export SNET_DIR=$HOME/snet
    module load openmpi/gnu
    ;;
  woot2*)
    export SNET_DIR=$HOME/Projects/snet
    ;;
  ohyeah4*)
    export GIT_AUTHOR_NAME="Riccardo M. Cefala"
    export GIT_AUTHOR_EMAIL="riccardo.cefala@mendix.com"
    export GIT_COMMITTER_NAME="Riccardo"
    export GIT_COMMITTER_EMAIL="riccardo.cefala@mendix.com"
    ;;
  *)
    export SNET_DIR=/opt/snet
    ;;
esac

#snet related
export LPEL_DIR=$SNET_DIR
export SNET_INCLUDES=$SNET_DIR/include/snet
export SNET_LIBS=$SNET_DIR/lib/snet
export SNET_MISC=$SNET_DIR/share/snet
export PATH=$SNET_DIR/bin:$PATH
export DYLD_LIBRARY_PATH=$SNET_LIBS:$SNET_DIR/lib:$LPEL_DIR
export LD_LIBRARY_PATH=$SNET_LIBS:$SNET_DIR/lib:$LPEL_DIR

#
# Funcs
#
keyadd() {
  ssh-add ~/.ssh/${1}/id_rsa || ssh-add -L
}

# set screen/tmux title
st() {
  [ -n "$TMUX" ]  && printf "\033k$1\033\\"
}

# set terminal title
stt() {
  echo -en "\e]0;$1\a"
}

settitle() {
  export TITLE_STRING="$*"
  st "$*"
  stt "$*"
}

crep() {
  grep -rn "${1}" *
}

snettestk() {
  local TESTS=$HOME/Projects/snet-rts/examples/tests/distributed
  cd $TESTS ; for i in $(ls -d */) ; do echo ${i%%//} ; killall -9 ${i%%//} ; done ;
  cd $OLDPWD
}

# set title upon ssh connections
ssh() {
    settitle "$*"
    command ssh "$@"
    settitle "bash"
}

# set terminal tab
PROMPT_COMMAND='stt "$TITLE_STRING $HOSTNAME:$PWD"'

#
# tmux/screen
# set ENABLE_TMUX in order to have tmux at startup
#
ENABLE_TMUX=
if which tmux >/dev/null 2>&1 && test $ENABLE_TMUX; then
 # force tmux in 256 colors
  alias tmux="tmux -2"

 # if no session is started, start a new session
  test -z ${TMUX} && (tmux attach || tmux new-session)
fi

#add home .bin to path
export PATH="$PATH:$HOME/.bin"

