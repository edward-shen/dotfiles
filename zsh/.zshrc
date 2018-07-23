export TERM=xterm-256color

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Enable fish highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Powerlevel 9k theme
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

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
export PATH=$PATH:/home/edward/.gem/ruby/2.5.0/bin

# Aliases
alias vi="nvim"
alias vim="nvim"
