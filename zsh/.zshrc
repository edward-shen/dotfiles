export TERM=xterm-256color

# ZSH config
DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="yyyy-mm-dd"

# Check compinit only once a day, should make loading faster
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Oh-my-zsh config
export ZSH=/usr/share/oh-my-zsh
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
# plugins can be found in ~/.oh-my-zsh/plugins/*
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Enable fish highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Powerlevel 9k theme
# Using Powerlevel 10k because faster
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Powerlevel 9k config
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir dir_writable_joined vcs)

POWERLEVEL9K_USER_DEFAULT_FOREGROUND="green"
POWERLEVEL9K_USER_DEFAULT_BACKGROUND="236"

POWERLEVEL9K_DIR_HOME_BACKGROUND="green"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="green"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="green"

POWERLEVEL9K_STATUS_OK_BACKGROUND="236"

POWERLEVEL9K_VCS_CLEAN_BACKGROUND="34"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="blue"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="yellow"

POWERLEVEL9K_TIME_BACKGROUND="yellow"

POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="196"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="green"

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# Adding thefuck alias
eval $(thefuck --alias)

# PATH exports
export PATH=$PATH:/home/edward/.cargo/bin
export PATH=$PATH:/home/edward/bin

# Aliases
alias vi="nvim"
alias vim="nvim"
alias rm="rm -I"
alias pdf="zathura --fork"
alias sl="ls"

# Lazy-load nvm, node
# https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/d5ib9fs/
declare -a NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")
load_nvm () {
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}
for cmd in "${NODE_GLOBALS[@]}"; do
    eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done

# Make make go fast, use 8 threads
export MAKEFLAGS="-j 8"

