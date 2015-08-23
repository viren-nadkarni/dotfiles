
alias df='df -h'
alias du='du -c -h'
alias ping='ping -c 4'

if [ $UID -ne 0 ]; then
    alias sudo='sudo -E'            # preserve environment
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias halt='sudo halt'
    alias reboot='sudo reboot'
    alias shutdown='sudo shutdown now'
fi

alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by ext
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date

alias ln='ln -i'

alias grep='grep --colour=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias less='less -r'
alias diff='colordiff'
alias tmux='tmux -2'

