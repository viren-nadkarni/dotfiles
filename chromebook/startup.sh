#!/bin/bash

dropbox start
libinput-gestures-setup start

# remap caps to ctrl
setxkbmap -option ctrl:nocaps

# remap super to ctrl
xmodmap -e "clear Control"
xmodmap -e "clear Mod4"
xmodmap -e "keysym Super_L = Control_L"\
xmodmap -e "add Control = Control_L"
xmodmap -e "add Mod4 = Super_L Super_R"

# make the uk layout a bit more tolerable
xmodmap -e 'keycode 51=Return'
xmodmap -e 'keycode 36=backslash bar'
xmodmap -e 'keycode 94=Shift_L'

# touchpad tweaks
xinput set-button-map 11 1 2 3 4 5
xinput set-prop 11 275 1

#export XDG_SESSION_TYPE="${XDG_SESSION_TYPE:-"x11"}"
