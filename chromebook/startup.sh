#!/bin/bash

dropbox start
libinput-gestures-setup start

xmodmap -e 'keycode 51=Return'
xmodmap -e 'keycode 36=backslash bar'
xmodmap -e 'keycode 94=Shift_L'

xinput set-button-map 11 1 2 3 4 5
xinput set-prop 11 275 1

#export XDG_SESSION_TYPE="${XDG_SESSION_TYPE:-"x11"}"
