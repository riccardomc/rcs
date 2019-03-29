#
# Oh My ZSH config
#
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rmc"

#
# Completion plugin config
#
COMPLETION_WAITING_DOTS="true"

#
# TMUX plugin config
#

# enable autostart only if not running on i3
[ ! -z "$(pgrep '^i3$')" ] && ZSH_TMUX_AUTOSTART=false || ZSH_TMUX_AUTOSTART=true

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/.cargo/bin:$HOME/.bin:$HOME/.scripts:$HOME/.local/bin:$PATH"
plugins=(git ssh-agent tmux docker kubectl history-substring-search fasd zsh-autosuggestions zsh-syntax-highlighting)

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

fixssh() {
  for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
    if (tmux show-environment | grep "^${key}" > /dev/null); then
      value=`tmux show-environment | grep "^${key}" | sed -e "s/^[A-Z_]*=//"`
      export ${key}="${value}"
    fi
  done
}

#
# Exports
#

source $ZSH/oh-my-zsh.sh

export GIT_AUTHOR_NAME="Riccardo M. Cefala"
export GIT_AUTHOR_EMAIL="riccardo.cefala@container-solutions.com"
export GIT_COMMITTER_NAME="Riccardo M. Cefala"
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

# grep through history
alias hg="history | grep"

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
bindkey '^t' history-incremental-pattern-search-forward

# Ctrl+space: print Git status
bindkey -s '^s' 'git status^M'

# Fix home end keys
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^u" backward-kill-line
bindkey "^k" kill-line
bindkey "^w" backward-kill-word
bindkey "^p" kill-word

bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

#
# NPM
#
# https://stackoverflow.com/a/13021677
#

# NPM packages in homedir
NPM_PACKAGES="$HOME/.npm-packages"

# Tell our environment about user-installed node tools
PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your configuration
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Tell Node about these packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
