#!/bin/bash

i3-msg "workspace 2; exec gnome-terminal"

sleep 0.2

i3-msg "workspace 1; \
        exec slack;\
        exec google-chrome --new-window \
            https://calendar.google.com/ \
            https://inbox.google.com/ \
            https://web.whatsapp.com/;" &
