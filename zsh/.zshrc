export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rmc"
COMPLETION_WAITING_DOTS="true"

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/.bin:$HOME/.scripts:$HOME/.local/bin:$PATH"
plugins=(git svn brew ssh-agent docker kubectl fasd zsh-syntax-highlighting)

#
# User config
#

#
# Functions
#
keyadd() {
  KEY_PREFIX='_key-'
  ssh-add ~/.ssh/${KEY_PREFIX}${1}/id_rsa || ssh-add -L
}

vactivate() {
    VENV=~/virtualenv/${PWD##*/}/bin/activate
    echo source $VENV
    source $VENV
}

osx() {
    [ $(uname) = 'Darwin' ]
}

linux() {
    [ $(uname) = 'Linux' ]
}

#
# Exports
#

source $ZSH/oh-my-zsh.sh

export GIT_AUTHOR_NAME="Riccardo Cefala"
export GIT_AUTHOR_EMAIL="riccardo.cefala@container-solutions.com"
export GIT_COMMITTER_NAME="Riccardo Cefala"
export GIT_COMMITTER_EMAIL="riccardo.cefala@container-solutions.com"
export EDITOR=$(which nvim)

# revert ls quoting behaviour introduced in coreutils 8.25
export QUOTING_STYLE=literal

#
# Golang
#
export GOROOT=$HOME/go
export GOPATH=$HOME/Development/golang
osx && export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

#
# Python (virtualenvwrapper)
#
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /home/rmc/.local/bin/virtualenvwrapper.sh

#
# Google Cloud SDK
#
source /home/rmc/opt/google-cloud-sdk/path.zsh.inc
source /home/rmc/opt/google-cloud-sdk/completion.zsh.inc

#
# Gradle
#
export PATH=$HOME/opt/gradle-4.5.1/bin:$PATH

#
# Aliases
#
alias mypublicip='wget http://ipinfo.io/ip -qO -'
alias vim=$(which nvim)
linux && alias pbcopy='xsel --clipboard --input'
linux && alias pbpaste='xsel --clipboard'
linux && alias vpnup='nmcli c up riccardo_teal --ask'
linux && alias vpndown='nmcli c down riccardo_teal'

# kubectl
alias k='kubectl'
alias kns='k get namespaces'

# Openfiles quick in vim with FASD
alias v='f -e nvim'


#
# Completion - aws, kubectl, ssh, ...
#
source <(kubectl completion zsh)
source ~/.local/bin/aws_zsh_completer.sh

# ssh host completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# enable vim bindings
bindkey -v
export KEYTIMEOUT=1
bindkey "^I" expand-or-complete-with-dots #fix dot completion

# backward and forward history search
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# Fix home end keys
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^u" backward-kill-line
bindkey "^k" kill-line
bindkey "^w" backward-kill-word

bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
