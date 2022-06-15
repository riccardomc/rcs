#!/usr/bin/env bash

# Disable bluetooth when sleeping
# https://apple.stackexchange.com/a/437397

brew install sleepwatcher blueutil
echo "$(which blueutil) -p 0" > ~/.sleep
echo "$(which blueutil) -p 1" > ~/.wakeup
chmod 755 ~/.sleep ~/.wakeup
brew services restart sleepwatcher
