setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
unsetopt AUTO_REMOVE_SLASH
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt EXTENDED_HISTORY

# PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.composer/vendor/bin:$PATH
export PATH=$PNPM_HOME:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/go/bin:$PATH
if [[ "$(uname -sm)" = "Darwin arm64" ]] then export PATH=/opt/homebrew/bin:$PATH; fi
export PATH=$HOME/Desktop/yazi/target/release:$PATH

# Autoload
autoload -U compinit; compinit
zmodload zsh/complist
autoload -Uz edit-command-line; zle -N edit-command-line

# Plugins
source $ZSHAREDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSHAREDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSHAREDIR/zsh-history-substring-search/zsh-history-substring-search.zsh
fpath=($ZSHAREDIR/zsh-completions/src $fpath)

[[ $- == *i* ]] && source $ZSHAREDIR/fzf/completion.zsh 2> /dev/null
source $ZSHAREDIR/fzf/key-bindings.zsh

# Auto completion
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"
source $ZDOTDIR/keymap.zsh

# Tabtab for node cli programs, e.g. `pnpm`
source $ZDOTDIR/tabtab/pnpm.zsh

# Initialize tools
source $ZDOTDIR/function.zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
