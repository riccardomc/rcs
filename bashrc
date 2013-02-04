# RMC
#
# ~/.bashrc: executed by bash(1) for non-login shells.
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#Try to set 256color TERM if supported
case "$TERM" in
*)
    POTENTIAL_TERM=${TERM}-256color
    POTENTIAL_TERMINFO=${TERM:0:1}/$POTENTIAL_TERM

    # better to check $(toe -a | awk '{print $1}') maybe?
    BOX_TERMINFO_DIR=/usr/share/terminfo
    [[ -f $BOX_TERMINFO_DIR/$POTENTIAL_TERMINFO ]] && \
        export TERM=$POTENTIAL_TERM

    HOME_TERMINFO_DIR=$HOME/.terminfo
    [[ -f $HOME_TERMINFO_DIR/$POTENTIAL_TERMINFO ]] && \
        export TERM=$POTENTIAL_TERM
    ;;
esac

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm*) color_prompt=yes;;
  screen*) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # we have color support; assume it's compliant with ecma-48
    # (iso/iec-6429). (lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# if this is an xterm set the title to user@host:dir
case "$term" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -a'
#alias l='ls -cf'

# alias definitions.
# you may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# see /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

##################
# my fancy stuff
##################

#
# aliases
#
if [ "$(uname)" = "Darwin" ]; then
  alias tgvim="mvim -p --remote-tab-silent"
  alias hname="hostname -f"
else
  alias tgvim="gvim -p --remote-tab-silent"
  alias hname="hostname -A"
fi

#
# exports
#

#only on mac
if [ "$(uname)" = "Darwin" ]; then
  #colorize cli
  export CLICOLOR=1

  export PYTHON_PATH="/opt/local//library/frameworks/python.framework/versions/2.7:$PYTHON_PATH"
  export XDG_DATA_DIRS="$PYTHON_PATH/share"

  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH

  #this is for vim installed by brew to have ruby support
  export PATH=/usr/local/cellar/vim/7.3.762/bin:$PATH
fi

#per host configs
case $(hname | cut -d " " -f 1) in
  fs*.das4.*)
    stty erase ^? #fix backspace
    export SNET_DIR=/var/scratch/$USER/snet
    module load gcc
    module load sge 
    ;;
  *.sara.nl)
    export SNET_DIR=$HOME/snet
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
# funcs and misc
#
keyadd() {
  ssh-add ~/.ssh/${1}/id_rsa || (echo using default key ; ssh-add ~/.ssh/id_rsa)
}

#
# tmux
#
if which tmux >/dev/null 2>&1; then
  #force tmux in 256 colors
  alias tmux="tmux -2"

  # if no session is started, start a new session
  test -z ${TMUX} && (tmux attach || tmux new-session)

  # when quitting tmux, try to attach
  #while test -z ${tmux}; do
  #    tmux attach || break
  #done
fi
