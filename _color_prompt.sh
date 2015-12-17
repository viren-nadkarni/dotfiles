#!/bin/bash

cat <<EOF | tee /etc/profile.d/color_prompt.sh > /dev/null 2>&1
if [[ ! -z \$BASH ]]; then
    if [[ \$EUID -eq 0 ]]; then
        PS1="\[\033[01;31m\]\u@\h\[\033[m\] \[\033[01;33m\]\W\[\033[m\] # "
    else
        PS1="\[\033[01;32m\]\u@\h\[\033[m\] \[\033[01;34m\]\W\[\033[m\] \$ "
    fi
fi
EOF

