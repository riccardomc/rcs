#!/bin/bash


sudo apt install -y \
    apt-transport-https \
    arandr \
    blueman \
    build-essential \
    ca-certificates \
    caffeine \
    cbatticon \
    compton \
    compton-conf \
    curl \
    copyq \
    dnsutils \
    ddcutil \
    docker-ce \
    feh \
    firmware-misc-nonfree \
    flake8 \
    gcal \
    git \
    gnupg \
    gparted \
    htop \
    i3 \
    i3lock-fancy \
    i7z \
    jq \
    kdiff3 \
    laptop-mode-tools \
    libcairo2-dev \
    libdbus-glib-1-dev \
    libgirepository1.0-dev \
    libnotify-bin \
    linux-cpupower \
    maim \
    maven \
    network-manager-openvpn \
    nmap \
    nmon \
    pasystray \
    pavucontrol \
    pipewire \
    powertop \
    python3-dev \
    python3-venv \
    python3-wheel \
    python3-xlib \
    redshift \
    rofi \
    ruby-dev \
    shellcheck \
    software-properties-common \
    solaar-gnome3 \
    tig \
    unrar \
    virtualenvwrapper \
    xautolock \
    xbacklight \
    xbacklight \
    xdg-desktop-portal-gtk \
    xournal \
    xsel \
    xserver-xorg-input-synaptics \
    yamllint \
    zim \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# third parties

# isync
# google-chrome

# git-delta
GIT_DELTA_VERSION=0.1.1
GIT_DELTA_DEB=~/Downloads/git-delta_${GIT_DELTA_VERSION}_amd64.deb
curl -s -C - -Lo $GIT_DELTA_DEB https://github.com/dandavison/delta/releases/download/$GIT_DELTA_VERSION/$GIT_DELTA_DEB
sudo apt install $GIT_DELTA_DEB

# bat - cat with wings
BAT_VERSION=0.15.4
BAT_DEB=~/Downloads/bat_${GIT_DELTA_VERSION}_amd64.deb
curl -s -C - -Lo $BAT_DEB https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
sudo apt install $BAT_DEB

# brave browser
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt install brave-browser

# nodejs
curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt install nodejs
