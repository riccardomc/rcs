#rmc Thu Dec  6 14:18:45 CET 2012
#
# bash profile on iMac in room C3.101 Building 904, Science Park, Amsterdam
# hostname: u020737.1x.uva.nl          
#

#
#binds
#

#history search on partial commands with arrow up and down 
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#
#exports
#

#snet related
SNET_DIR=/opt/snet
LPEL_DIR=$SNET_DIR
export SNET_INCLUDES=$SNET_DIR/include/snet
export SNET_LIBS=$SNET_DIR/lib/snet
export SNET_MISC=$SNET_DIR/share/snet
export PATH=$PATH:/opt/snet/bin
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$SNET_LIBS:$LPEL_DIR
export DYLD_LIBRARY_PATH=$SNET_LIBS:$LPEL_DIR

#colorize CLI
export CLICOLOR=1

#to make zim happy
export PYTHON_PATH="$PYTHON_PATH:/opt/local//Library/Frameworks/Python.framework/Versions/2.7"
export XDG_DATA_DIRS="$PYTHON_PATH/share"

#MacPorts PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

#
#aliases
#
alias grep="grep --color"
alias tvim="vim -p --remote-tab-silent"
alias tgvim="mvim -p --remote-tab-silent"

#
# color prompt
#
color_prompt=yes
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi


#
# Startup
#

# TMUX
if which tmux 2>&1 >/dev/null; then
    # if no session is started, start a new session
    test -z ${TMUX} && tmux

    # when quitting tmux, try to attach
    while test -z ${TMUX}; do
        tmux attach || break
    done
fi
