# Zsh root
ZDOTDIR=$HOME/.config/zsh

# Zsh related
HISTFILE=$ZDOTDIR/.history
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=1  # makes the switch between modes quicker
HISTORY_SUBSTRING_SEARCH_PREFIXED=1  # enables prefixed search for zsh-history-substring-search

# Software specific
export EDITOR="nvim"
export VISUAL="nvim"
export HOMEBREW_NO_ANALYTICS=1
export FZF_DEFAULT_OPTS="
--reverse --bind=ctrl-u:up,ctrl-e:down
--border --color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
"
export RANGER_LOAD_DEFAULT_RC="FALSE"

