# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/.bin:$HOME/.scripts:$PATH"
plugins=(git svn brew ssh-agent docker fasd zsh-syntax-highlighting)

# User configuration

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
    [ $(uname) = 'Darwin' ]
}

#
# Exports
#

source $ZSH/oh-my-zsh.sh

export GIT_AUTHOR_NAME="Riccardo M. Cefala"
export GIT_AUTHOR_EMAIL="riccardo.cefala@gmail.com"
export GIT_COMMITTER_NAME="Riccardo"
export GIT_COMMITTER_EMAIL="riccardo.cefala@gmail.com"
export EDITOR=$(which nvim)

#
# Golang
#
export GOROOT=$HOME/go
export GOPATH=$HOME/Development/golang
osx && export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


#
# Aliases
#

alias mypublicip='wget http://ipinfo.io/ip -qO -'
alias vim=$(which nvim)

#
# For SSH Host Completion - Zsh Style
#
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# enable vim bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^r' history-incremental-pattern-search-backward

# Fix home end keys
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

