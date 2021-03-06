#!/bin/bash

# install chezmoi

if ! [ -x "$(command -v chezmoi)" ] ; then
    curl -sfL https://git.io/chezmoi | bash -s -- -d -b ~/.bin
fi

PATH=~/.bin:$PATH
#chezmoi init --apply --verbose --dry-run https://github.com/riccardomc/rcs.git
chezmoi init https://github.com/riccardomc/rcs.git
chezmoi diff

COMPLETION_DST="$HOME/.oh-my-zsh/completions"
mkdir -p "$COMPLETION_DST"
chezmoi completion zsh > "$COMPLETION_DST/_chezmoi" 
