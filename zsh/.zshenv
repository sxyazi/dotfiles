# Zsh root
ZDOTDIR=$HOME/.config/zsh
ZSHAREDIR=$HOME/.local/share/zsh

# Zsh related
HISTFILE=$ZDOTDIR/.history
HISTSIZE=10000
SAVEHIST=10000
KEYTIMEOUT=1  # makes the switch between modes quicker
HISTORY_SUBSTRING_SEARCH_PREFIXED=1  # enables prefixed search for zsh-history-substring-search

# Temporary variables
__TREE_IGNORE="-I '.git' -I '*.py[co]' -I '__pycache__' $__TREE_IGNORE"
__FD_COMMAND="-L -H --no-ignore-vcs ${__TREE_IGNORE//-I/-E} $__FD_COMMAND"

# Software specific
export EDITOR="nvim"
export VISUAL="nvim"

export BAT_THEME="Catppuccin Mocha"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_DOWNLOAD_CONCURRENCY=8
export PNPM_HOME=$HOME/Library/pnpm

export LESSKEYIN=$HOME/.config/less/.lesskey
export LESSHISTFILE=$HOME/.config/less/.lesshst

export FZF_DEFAULT_COMMAND="fd $__FD_COMMAND"
export FZF_DEFAULT_OPTS="
--reverse --ansi
--bind=ctrl-u:up,ctrl-e:down,ctrl-n:backward-char,ctrl-i:forward-char,ctrl-b:backward-word,ctrl-h:forward-word,tab:toggle+down,shift-tab:toggle+up,ctrl-a:select-all,ctrl-r:toggle-all
--border --scrollbar=▌"

# Clean up
unset __TREE_IGNORE
unset __FD_COMMAND
