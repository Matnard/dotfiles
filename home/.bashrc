#
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(direnv hook bash)"
export PATH=$PATH:$(go env GOPATH)/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH="$HOME/.local/bin:$PATH"
LOGGER="$HOME/.config/node/logger.js"
if [ -f "$LOGGER" ]; then
  export NODE_OPTIONS="--require $LOGGER"
fi

source ~/.aliases
