#!/bin/bash

i3-msg "workspace 3; exec gnome-terminal"

sleep 1

i3-msg "workspace 2; \
        exec google-chrome --new-window \
        https://sprintr.home.mendix.com; 
        exec slack" &

sleep 3

i3-msg "workspace 1; \
        exec google-chrome --new-window \
            https://webmail.mendix.com/ \
            https://inbox.google.com/ \
            https://web.whatsapp.com/" &

