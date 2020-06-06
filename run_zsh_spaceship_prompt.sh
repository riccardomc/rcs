#!/bin/bash

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
SPACESHIP_PROMPT_CHECKOUT=$ZSH_CUSTOM/themes/spaceship-prompt
SPACESHIP_PROMPT_REPO=https://github.com/denysdovhan/spaceship-prompt.git

echo Installing ZSH spaceship prompt...
if cd "$SPACESHIP_PROMPT_CHECKOUT"; then
    git pull
else 
    git clone $SPACESHIP_PROMPT_REPO "$SPACESHIP_PROMPT_CHECKOUT"
fi

# This is done by chezmoi
#ln -fs "$SPACESHIP_PROMPT_CHECKOUT/spaceship.zsh-theme" \
#       "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
