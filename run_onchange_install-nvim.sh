#!/bin/bash

# just exit if we're not on Linux
uname -a | grep Linux || exit 0

CUSTOM_NVIM_PATH=/usr/local/bin/nvim.appimage

if ! [ -f "$CUSTOM_NVIM_PATH" ] ; then
    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod +x nvim.appimage
    sudo mv nvim.appimage $CUSTOM_NVIM_PATH

    set -u
    sudo update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
    sudo update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
    sudo update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
    sudo update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
    sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110
fi
