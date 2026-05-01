export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode disabled
# zstyle ':omz:update' frequency 30

plugins=(git)

source $ZSH/oh-my-zsh.sh

# alias para usar vim en lugar de vi
alias vi=vim

# alias para evitar eliminar permanentemente
# alias rm=trash

# alias para usar el comando open
alias open='xdg-open'
