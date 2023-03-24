setopt AUTO_CD
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_ALL_DUPS

# PATH
export PATH=~/.composer/vendor/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=~/go/bin:$PATH
if [[ "$(uname -sm)" = "Darwin arm64" ]] then export PATH=/opt/homebrew/bin:$PATH; fi

# Autoload
autoload -U compinit; compinit
zmodload zsh/complist
autoload -Uz edit-command-line; zle -N edit-command-line

# Plugins
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# Auto completion
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"
source $ZDOTDIR/keymap.zsh

# Initialize tools
source $ZDOTDIR/function.zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

