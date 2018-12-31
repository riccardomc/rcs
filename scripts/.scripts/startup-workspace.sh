#!/bin/bash

i3-msg "workspace 2; exec gnome-terminal"

sleep 0.2

i3-msg "workspace 1; \
        exec slack;\
        exec google-chrome --new-window \
            https://calendar.google.com/calendar/b/1/r?u=1 \
            https://mail.google.com/mail/u/1/ \
            https://web.whatsapp.com/;" &
